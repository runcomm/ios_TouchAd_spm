//
//  CardRegistViewController.swift
//  touchad
//
//  Created by shimtaewoo on 2020/08/26.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

//class CardRegistViewController: BaseViewController, KeyboardDelegate {
class CardRegistViewController: BaseViewController, UITextFieldDelegate, KeyboardToolbarDelegate {
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var cardCompanyButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerViewTopConstraint: NSLayoutConstraint!
    
    private var cardCompanyList: [CardCompany]?
    private var cardCompanyIdx: Int? = -1
    public var cardUsrIdx: String? = ""
    public var cardNumber: String? = ""
    public var cardCompany: String? = ""
    public var cardCompanyNo: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registButton.setTitleColor(UIColor.rgb(255,255,255), for: .normal)
        registButton.isEnabled = false
        registButton.backgroundColor = UIColor.rgb(213,213,213)

        let doneButton = UITextField.ToolbarItem(title: TAConstants.COMMON_KEYBOARD_COMPLETE_TITLE, target: self, selector: #selector(donePressed))
        textField1.delegate = self

        textField1.addToolbar(leading: [], trailing: [doneButton])
        
        //textField1.becomeFirstResponder()
        
        registerForKeyboardNotifications()
        
        requestCardCompanyList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
        //self.navigationController?.popViewController(animated: true)
        afterRegistViewController()
    
    }
    
    @IBAction func openCardCompanyList(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        var nameList = [String]()
        
        nameList.append(TAConstants.CARD_COMPANY_GUIDE_MESSAGE)
        
        self.cardCompanyList?.forEach { (cardCompany) in
            nameList.append(cardCompany.company ?? "이름 없음")
        }
        
        CommonPickerPopupView.createView(self.view, list: nameList, selectIndex: self.cardCompanyIdx) { (index) in
            if index > 0 {
                self.cardCompanyIdx = index - 1
                self.cardCompanyButton.setTitleColor(.black, for: .normal)
                self.cardCompanyButton.setTitle(nameList[index], for: .normal)
                self.cardCompanyNo = self.cardCompanyList![index - 1].no
                self.textField1.becomeFirstResponder()
                
                let isTextCount = self.textField1.text?.count ?? 0 >= 14
                
                if (isTextCount)
                {
                    self.registButton.isEnabled = true
                    self.registButton.backgroundColor = UIColor.rgb(50,3,202)
                }
                else
                {
                    self.registButton.isEnabled = false
                    self.registButton.backgroundColor = UIColor.rgb(213,213,213)
                }
            }
        }
        
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        requestCardInsert()
    
    }
    
    private func requestCardCompanyList() {

        let parameters = [String:String]()

        NetworkRequest.requestCardCompanyList(self, parameters: parameters, success: { (response) in
            if response.result == 1
            {
                self.cardCompanyList = response.data
            }
        }){ (response, error, isProcess) in
            self.showErrorAndRefreshAccessToken(response, error, isProcess)
        }

    }
    
    private func afterRegistViewController() {

        if (self.navigationController != nil)
        {
            let vcs: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            
            if vcs.count >= 2 , let vc = vcs[vcs.count - 2] as? CommonWebViewController
            {
                if vc.webView.url!.absoluteString.contains(TAConstants.WEBURL_TOUCHAD_MAIN) || vc.webView.url!.absoluteString.contains(TAConstants.WEBURL_BOARD_INFO)
                {
                    vc.reloadWebView()
                    self.navigationController!.popToViewController(vc, animated: true)
                    return
                }
            }
            
            if vcs.count >= 3 , let vc = vcs[vcs.count - 3] as? CommonWebViewController
            {
                if vc.webView.url!.absoluteString.contains(TAConstants.WEBURL_TOUCHAD_MAIN)
                {
                    vc.reloadWebView()
                    self.navigationController!.popToViewController(vc, animated: true)
                    return
                }
            }
        }
    }
    
    private func requestCardInsert() {
        
        textField1.resignFirstResponder()

        let usrIdx = cardUsrIdx
        let cardNo = textField1.text!
        let platformId = TAGlobalManager.platformId
        //let no = cardCompanyList![cardCompanyIdx!].no
        
        startIndicator()
        
        NetworkRequest.requestCardInsert(self, usrIdx: usrIdx, cardNo: cardNo, no: cardCompanyNo, platformId: platformId, success: {(response) in
            
            self.stopIndicator()

            CommonPopupView.createView(self.view, title: TAConstants.CARD_SUCCESS_TITLE , text: TAConstants.CARD_SUCCESS_MESSAGE, textAlign: .center, confirmText: TAConstants.COMMON_CONFIRM_TITLE, confirmAction: {() in
                let insertResult = response.result
                
                NetworkRequest.requestGetMPPushCheck(self, mbrId: TAGlobalManager.mbrId, success: {(response) in
                    let appPushYn = response.data?[0].notiYn
                    let adPushYn = response.data?[0].adsNotiYn
                    let mbrId = response.data?[0].mbrId
                    
                    if (appPushYn == TAConstants.YES && adPushYn == TAConstants.YES)
                    {
                        self.afterRegistViewController()
                    }
                    else
                    {
                        BottomPopupView.createView(self.view, appPushYn, adPushYn, confirmAction: {() in
                            NetworkRequest.reqeustSetMPPush(self, appPushYn: TAConstants.YES, adPushYn: TAConstants.YES, mbrId: mbrId ,success: {(response) in
                                self.afterRegistViewController()
                            }, failure: {(response, error, isProcess) in
                                NetworkManager.sharedInstance.defaultFailFunc(self, response: response, error: error, isProcess: isProcess)
                            })
                        }, cancelAction: {() in
                            self.afterRegistViewController()
                        })
                    }
                }, failure: { (response, error, isProcess) in
                    NetworkManager.sharedInstance.defaultFailFunc(self, response: response, error: error, isProcess: isProcess)
                    self.afterRegistViewController()
                })
            })
        }, failure: { (response, error, inProcess) in
            self.stopIndicator()
            self.showErrorAndRefreshAccessToken(response, error, inProcess)
            
        })
        
    }
    
    // 이 메서드를 뷰 컨트롤러를 초기화하는 코드 부(e.g. viewDidLoad())에서 호출한다.
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      else {
        // if keyboard size is not available for some reason, dont do anything
        return
      }

      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 20 , right: 0.0)
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
      //registButton.isHidden = true
    }

    // 이 메서드는 UIKeyboardWillHide 노티피케이션을 받으면 호출된다.
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        //registButton.isHidden = false
    }
    
    
    override func showErrorAndRefreshAccessToken(_ response : BaseResponse?, _ error : Error?, _ isProcess : Bool)
    {
        //super.showErrorAndRefreshAccessToken(response, error, isProcess)
        if let response = response
        {
            if response.result == TAConstants.ACCESS_TOKEN_EXPIRE_ERROR
            {
                //self.showAlert(TAConstants.ACCESS_TOKEN_REFRESH_TITLE){() in

                    let platformId = TAGlobalManager.platformId
                    NetworkRequest.requestJWTRefresh(self, mbrId: TAGlobalManager.mbrId, platformId: platformId, success: {(response) in
                        if let user = response.data?[0] as User? {
                            TAGlobalManager.accessToken = user.accessToken ?? ""
                            self.viewWillAppear(false)
                        }
                    }, failure: {(response, error, isProcess) in
                        self.showAlert(TAConstants.COMMON_POPUP_TITLE, TAConstants.ACCESS_TOKEN_REFRESH_ERROR)
                    })
                    
                //}
            }
            else
            {
                CommonPopupView.createView(self.view, title: TAConstants.CARD_ERROR_TITLE , text: response.error!, textAlign: .center, confirmText: TAConstants.COMMON_CONFIRM_TITLE, confirmAction: {() in
                    self.textField1.becomeFirstResponder()
                })
            }
        }
        else
        {
            self.stopIndicator()
            self.showAlert(TAConstants.COMMON_POPUP_TITLE, TAConstants.NETWORK_ERROR_MESSAGE)
        }
    }
    
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOf textField: UITextField) {
        printd("Tapped button type: \(type) | \(textField)")
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        printd("Tapped text field: \(textField.text!)")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        printd("shouldChangeCharactersIn : \(textField.text!) | \(range.description) | \(string)")
        
        let size = textField.text!.count + string.count - range.length
        let isTextCount = size >= 14
        let isCardCompanySelect = cardCompanyNo != ""
        
        if (isTextCount && isCardCompanySelect)
        {
            registButton.isEnabled = true
            registButton.backgroundColor = UIColor.rgb(50,3,202)
        }
        else
        {
            registButton.isEnabled = false
            registButton.backgroundColor = UIColor.rgb(213,213,213)
        }
        
        if(size > 16)
        {
            return false
        }
        else
        {
            return true
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
    
    @IBAction func donePressed(_ sender: Any) {
        if textField1.isFirstResponder
        {
            textField1.resignFirstResponder()
        }
    }
}
