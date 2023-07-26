//
//  CardCaptureViewController.swift
//  touchad
//
//  Created by shimtaewoo on 2020/08/27.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import AVFoundation

class CardCaptureViewController: BaseViewController, CardIOViewDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerViewTopConstraint: NSLayoutConstraint!
    
    var captureSession: AVCaptureSession!
    //var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    //var cardIOView: CardIOView!
    
    public var cardUsrIdx: Int? = -1
    public var cardIsSignUp: Int? = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        /*self.scrollView.applyGradient(with: [
                UIColor.rgb(64,64,193),
                UIColor.rgb(136,45,214)
            ], gradient: .vertical)*/
        
        /*let scrollHeight = self.scrollView.frame.height
        let viewHeight = self.bannerView.frame.origin.y + self.bannerView.frame.height
        if scrollHeight > viewHeight
        {
            let val = bannerViewTopConstraint.constant
            bannerViewTopConstraint.constant = val + (scrollHeight - viewHeight)
        }*/
        /*
        let vframe = self.view.frame
        let pframe = self.previewView.frame
        let nw = pframe.size.width
        let nh = (vframe.size.height*pframe.size.width)/vframe.size.width
        //let rect = CGRect(x:-1 * (vframe.size.width - pframe.size.width)/2,y:-1 * (vframe.size.height - pframe.size.height)/2,width:vframe.size.width,height:vframe.size.height)
        let rect = CGRect(x:-1 * (nw - pframe.size.width)/2,y:-1 * (nh - pframe.size.height)/2,width:nw,height:nh)
        
        printd("rect = \(rect)")
        let cardIOView = CardIOView(frame:rect)
        cardIOView.allowFreelyRotatingCardGuide = true
        cardIOView.detectionMode = CardIODetectionMode.cardImageOnly
        previewView.addSubview(cardIOView)
        previewView.clipsToBounds = true
        
        if CardIOUtilities.canReadCardWithCamera()
        {
            cardIOView.delegate = self
        }
        else
        {
            print("Error Unable to initialize back camera")
        }
        */
        //capturePhoto()
        /*
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            if (captureSession.canAddInput(input)) {
                captureSession.addInput(input)
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
        //printd("previewView.cameraPreviewFrame = \(previewView.cameraPreviewFrame)")
         /*
        if let sublayers = cardIOView.layer.sublayers {
            for layer in sublayers {
                printd("layer = \(layer)")
                printd("layer.frame = \(layer.frame)")
                if let ssublayers = layer.sublayers {
                    for slayer in ssublayers
                    {
                        if let vlayer = slayer as? AVCaptureVideoPreviewLayer //CardIOGuideLayer
                        {
                            vlayer.videoGravity = .resizeAspectFill
                            vlayer.frame = layer.bounds
                            //layer.layoutIfNeeded()
                            //vlayer.removeFromSuperlayer()
                            printd("slayer = \(slayer)")
                            printd("slayer.frame = \(slayer.frame)")
                        }

                    }
                }
                
            }
        }*/
        //setupLivePreview()
        //NSLog("scrollView height : \(self.scrollView.frame.height)")
        //NSLog("bannerlView y + height : \( self.bannerView.frame.origin.y + self.bannerView.frame.height)")
        
        initializeCardIO()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //CardIOUtilities.preloadCardIO()
        //self.captureSession.stopRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.captureSession.stopRunning()
        imageView.isHidden = true
    }
    
    func setupLivePreview() {
        
        //stillImageOutput = AVCapturePhotoOutput()
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        let sublayer = previewView.layer.sublayers![0]
        previewView.layer.addSublayer(videoPreviewLayer)
        sublayer.sublayers?.insert(videoPreviewLayer, at: 0)
        //Step12
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
                
            self.captureSession.startRunning()
            
            //Step 13
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.layer.bounds
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cardRegistAction(_ sender: UIButton) {
        
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        let vc = CardRegistViewController(nibName: "CardRegistViewController", bundle: bundle)
        vc.cardUsrIdx = self.cardUsrIdx
        vc.cardIsSignUp = self.cardIsSignUp
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func cardIOView(_ sender: CardIOView, didScanCard info: CardIOCreditCardInfo){

        printd("cardIOView = \(info)")
        
        if AVCaptureDevice.authorizationStatus(for: .video) !=  .authorized {
            return
        }
        else if let cardNumber = info.cardNumber, !cardNumber.isEmpty
        {
            //NSLog("Received card info. Number: %@, expiry: %02i/%i", info.redactedCardNumber, info.expiryMonth, info.expiryYear);
            openCardRegistViewController(cardNumber)
        }
        else
        {
            if info == nil
            {
                return
            }
            
            if !self.imageView.isHidden
            {
                return
            }
            
            self.imageView.isHidden = false
            self.imageView.image = info.cardImage
            
            self.startIndicator()
            NetworkRequest.requestVisionUpload(self, image: info.cardImage, success: { [self]
                (response) in
                self.stopIndicator()
                
                if response.result! > 0
                {
                    if let cardNumber = response.data?[0].cardNumber as String? {
                        NSLog("cardNumber : %@", cardNumber)
                        //self.showAlert(cardNumber)
                        let image = self.drawRectanglesOnImage(image: self.imageView.image!, rectangles: (response.data?[0].rectangles)!)
                        self.imageView.image = image
                        let checkNumber = cardNumber.replacingOccurrences(of: " ", with: "")
                        if checkNumber.isValidCreditCard()
                        {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                                self.openCardRegistViewController(checkNumber)
                            }
                        }
                        else
                        {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                                let msg = checkNumber.isEmpty ? TAConstants.CARD_NUMBER_CAPTURE_FAIL_MESSAGE : String(format: TAConstants.CARD_NUMBER_CAPTURE_INCORRECT_FORMAT, cardNumber)
                                self.showAlert(TAConstants.COMMON_POPUP_TITLE, msg, {() in
                                    //self.openCardRegistViewController(nil)
                                    imageView.isHidden = true
                                    let sview = previewView.subviews[0]
                                    sview.removeFromSuperview()
                                    initializeCardIO()
                                })
                            }
                        }
                    }
                    else
                    {
                        self.showAlert(TAConstants.COMMON_POPUP_TITLE, TAConstants.CARD_NUMBER_CAPTURE_FAIL_MESSAGE, {() in
                            //self.openCardRegistViewController(nil)
                            imageView.isHidden = true
                            let sview = previewView.subviews[0]
                            sview.removeFromSuperview()
                            initializeCardIO()
                            
                        })
                    }
                }
                else
                {
                    self.showAlert(TAConstants.COMMON_POPUP_TITLE, response.error ?? TAConstants.NETWORK_ERROR_MESSAGE, {() in
                        //self.openCardRegistViewController(nil)
                        imageView.isHidden = true
                        let sview = previewView.subviews[0]
                        sview.removeFromSuperview()
                        initializeCardIO()
                    })
                }
                                
                
            }, failure: {(response, error, isProcess) in
                self.stopIndicator()
                self.showErrorAndRefreshAccessToken(response, error, isProcess)
            })

            
        }
        
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        /*let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        stillImageOutput.capturePhoto(with: settings, delegate: self)*/
    }
    
    func capturePhoto(){
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000)) {
            print("BOOYAH!")
            NSLog("subview size : %d" , self.cardIOView.subviews.count)
            
            if let sublayers = self.cardIOView.layer.sublayers {
                for layer in sublayers {
                    if let ssublayers = layer.sublayers {
                        for slayer in ssublayers{
                            if let vlayer = slayer as? AVCaptureVideoPreviewLayer //CardIOGuideLayer
                            {
                                let renderer = UIGraphicsImageRenderer(size: self.cardIOView.bounds.size)
                                let image = renderer.image { ctx in
                                    //self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
                                    //self.previewView.layer.render(in: ctx.cgContext)
                                    if let pLayer = vlayer.presentation()
                                    {
                                        pLayer.render(in: ctx.cgContext)
                                    }
                                }
                                self.imageView.image = image
                                
                            }
                        }
                    }
                    
                }
            }
            self.capturePhoto()
        }
        */
    }
    
    
    func openCardRegistViewController(_ cardNumber: String?){
        
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        let vc = CardRegistViewController(nibName: "CardRegistViewController", bundle: bundle)
    
        if let cardNumber = cardNumber
        {
            NetworkRequest.requestBincodeSelect(self, cardNo:cardNumber, success: { (response) in
                
                if response.result == 1
                {
                    if let no = response.data?[0].no
                    {
                        vc.cardCompanyNo = no
                    }
                    if let name = response.data?[0].name
                    {
                        vc.cardCompany = name
                    }
                    
                    vc.cardUsrIdx = self.cardUsrIdx
                    vc.cardIsSignUp = self.cardIsSignUp
                    vc.cardNumber = cardNumber
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }){ (response, error, isProcess) in
                
                vc.cardUsrIdx = self.cardUsrIdx
                vc.cardIsSignUp = self.cardIsSignUp
                vc.cardNumber = cardNumber
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else
        {
            vc.cardUsrIdx = self.cardUsrIdx
            vc.cardIsSignUp = self.cardIsSignUp
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

        
    }
    
    func drawRectanglesOnImage(image: UIImage, rectangles: [Rectangle]) -> UIImage {
        
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let context = UIGraphicsGetCurrentContext()

        image.draw(at: CGPoint.zero)
        
        for rectangle in rectangles {
            let rect = CGRect(x: rectangle.x ?? 0, y: rectangle.y ?? 0, width: rectangle.width ?? 0, height: rectangle.height ?? 0)
            //context!.setFillColor(UIColor.red.cgColor)
            context!.setStrokeColor(UIColor.red.cgColor)
            //context!.addRect(rect)
            context!.stroke(rect, width: 2)
        }
        
        //context!.drawPath(using: .stroke)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
    func initializeCardIO(){
        
        let vframe = self.view.frame
        let pframe = self.previewView.frame
        let nw = pframe.size.width
        let nh = (vframe.size.height*pframe.size.width)/vframe.size.width
        //let rect = CGRect(x:-1 * (vframe.size.width - pframe.size.width)/2,y:-1 * (vframe.size.height - pframe.size.height)/2,width:vframe.size.width,height:vframe.size.height)
        let rect = CGRect(x:-1 * (nw - pframe.size.width)/2,y:-1 * (nh - pframe.size.height)/2,width:nw,height:nh)
        
        printd("rect = \(rect)")
        let cardIOView = CardIOView(frame:rect)
        cardIOView.scanInstructions = ""
        cardIOView.allowFreelyRotatingCardGuide = true
        cardIOView.detectionMode = CardIODetectionMode.cardImageOnly
        previewView.addSubview(cardIOView)
        previewView.clipsToBounds = true
        
        if CardIOUtilities.canReadCardWithCamera()
        {
            cardIOView.delegate = self
        }
        else
        {
            print("Error Unable to initialize back camera")
        }
        
    }
    
    
    @IBAction func bannerUsageAction(_ sender: UIButton) {
        //WEBURL_USAGE_GUIDE
        TAGlobalManager.pushCommonWebViewController(self, url: TAConstants.WEBURL_USAGE_GUIDE)
    }

    @IBAction func bannerPrivacyAction(_ sender: UIButton) {
        //WEBURL_USER_AGREE_PRIVATE
        TAGlobalManager.pushCommonWebViewController(self, url: TAConstants.WEBURL_USER_AGREE_PRIVATE)
    }

    
}

/*
extension CardCaptureViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        if let error = error {
            print("error occured : \(error.localizedDescription)")
        }

        if let dataImage = photo.fileDataRepresentation() {
            print(UIImage(data: dataImage)?.size as Any)

            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)

            /**
               save image in array / do whatever you want to do with the image here
            */
            self.imageView.image = image

        } else {
            print("some error here")
        }
    }
}
*/
