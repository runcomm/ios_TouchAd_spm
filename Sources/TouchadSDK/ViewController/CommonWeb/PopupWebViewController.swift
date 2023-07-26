//
//  PopupWebViewController.swift
//  touchad
//
//  Created by shimtaewoo on 2020/09/14.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import WebKit
//import SnapKit
import AdSupport
import AppTrackingTransparency

class PopupWebViewController: BaseViewController, TAWebViewInterface {
    
    var webView: WKWebView!
    private var webViewDelegate: TAWebViewDelegate?
    @IBOutlet weak var blockView: UIView!
    
    var titleName: String?

    //weak var delegateSelectMap : SelectMapProtocol?
    weak var openerViewController : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        blockView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAction(_:))))
        //blockView.isUserInteractionEnabled = true
        //remove webview cache, apply for fixed page
        if let title = screenName() as String? {
            self.titleLabel?.text = title
            if title == ""
            {
                self.titleContainerView?.frame.size = CGSize(width:0, height:0)
            }
        }
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        initWebView()
        //goNavigationLink() 
        
        if #available(iOS 14.0, *) {
            
            ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                    case .authorized:
                        print("authorized")
                        DispatchQueue.main.async {
                            self.goNavigationLink()
                        }
                    default:
                        DispatchQueue.main.async {
                            TAGlobalManager.createPromptCommonPopupView(self, confirmAction: {() in
                                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                                self.navigationController?.popViewController(animated: true)
                            }, cancelAction: {() in
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                }
            }
        }
        else
        {
            if (!ASIdentifierManager.shared().isAdvertisingTrackingEnabled)
            {
                DispatchQueue.main.async {
                    TAGlobalManager.createPromptCommonPopupView(self, confirmAction: {() in
                        UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                        self.navigationController?.popViewController(animated: true)
                    }, cancelAction: {() in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.goNavigationLink()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*if self.presentedViewController == nil
        {
            let urlObj = URL(string:TAConstants.URL_MOVIE_STOP)
            webView.load(URLRequest(url: urlObj!))
        }*/
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        deleteUrlStackTouchAd()
//        printd("deleteUrlStackTouchAd = \(TAWebViewDelegate.urlStack)")
        if let urlStr = url, urlStr.contains(TAConstants.WEBURL_ADVERTISE_SELECT)
        {
           if let vc = UIApplication.shared.keyWindow?.visibleViewController as? UIViewController {

               if let cwc = vc as? CommonWebViewController {
                   if (cwc.webView.url!.absoluteString.contains(TAConstants.WEBURL_APPRL_NO_LIST)){
                       cwc.reloadWebView()
                   }
                   
               }
           }
        }
    }

    //최상위 화면의 navigationController 상태와 CommonWebViewController 화면인지 체크하는 함수
    private func deleteUrlStackTouchAd() {
        if let vc = UIApplication.shared.keyWindow?.visibleViewController as? UIViewController {

            let pwc = vc as? PopupWebViewController

            if (self.navigationController != nil) {
                if (pwc == nil)
                {
                    TAWebViewDelegate.urlStack.pop()
                }
            }
            else
            {
                //광고상세 -> 광고리스트
                TAWebViewDelegate.urlStack.pop()
            }

        }
    }
    
    override func goNavigationLink()
    {
        if let urlStr = url, let urlObj = URL(string: urlStr.getFullUrl()) {
            
            let platformId = TAGlobalManager.platformId as String?
            let adPushYn = TAGlobalManager.adPushYn as String?
            let gender = TAGlobalManager.gender as String?
            let birthYear = TAGlobalManager.birthYear as String?
            let osVersion = TAUtil.getOsVersion()
            let appVersion = TAUtil.getAppVersion()
            let bannerYn = TAGlobalManager.bannerYn as String?
            
            if let mbrId = TAGlobalManager.mbrId as String?
            {

                if urlStr.contains(TAConstants.WEBURL_ADVERTISE_LIST) ||
                urlStr.contains(TAConstants.WEBURL_ADVERTISE_SELECT) ||
                urlStr.contains(TAConstants.WEBURL_ADVERTISE_MOVIE_TEST) ||
                urlStr.contains(TAConstants.WEBURL_USER_MYPAGE_TOUCHAD) ||
                urlStr.contains(TAConstants.WEBURL_TOUCHAD_MAIN)
                {
                    let urlObj = urlObj
                    .appendingNonExistence("mbrId",value: mbrId)
                    .appendingNonExistence("comm",value: "Z")
                    .appendingNonExistence("os",value: TAConstants.OS)
                    .appendingNonExistence("platformId",value: platformId)
                    .appendingNonExistence("adsId",value: TAUtil.getADID())
                    .appendingNonExistence("adPushYn",value: adPushYn)
                    .appendingNonExistence("gender",value: gender)
                    .appendingNonExistence("birthYear",value: birthYear)
                    .appendingNonExistence("osVersion",value: osVersion)
                    .appendingNonExistence("appVersion",value: appVersion)
                    webView.load(URLRequest(url: urlObj))
                }
                else
                {
                    if let usrIdx = TAGlobalManager.userInfo["usr_idx"] as? Int
                    {
                        let urlObj = urlObj
                        .appendingNonExistence("usrIdx",value: String(usrIdx))
                        .appendingNonExistence("comm",value: "Z")
                        .appendingNonExistence("os",value: TAConstants.OS)
                        .appendingNonExistence("osVersion",value: osVersion)
                        .appendingNonExistence("appVersion",value: appVersion)
                        webView.load(URLRequest(url: urlObj))
                    }
                }
            }
            else
            {
                let urlObj = urlObj
                .appendingNonExistence("comm",value: "Z")
                .appendingNonExistence("os",value: TAConstants.OS)
                .appendingNonExistence("osVersion",value: osVersion)
                .appendingNonExistence("appVersion",value: appVersion)
                webView.load(URLRequest(url: urlObj))
            }
            
        } else {
            showAlert("잘못된 url입니다.") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func screenName() -> String {
        
        if (url!.contains(TAConstants.WEBURL_GUIDE))
        {    return "\(TAUtil.getServiceSuffix())" }
        else if (url!.contains(TAConstants.WEBURL_LOGIN))
        {    return "\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_SETTING))
        {    return "설정\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_SING_UP_ADDITIONAL))  //회원정보 추가
        {   return "\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_SING_UP_COMPLETE)) //회원가입 완료
        {   return "\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_USER_MYPAGE_TOUCHAD))  //mypage skt
        {    return "MyPage\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_USER_AGREE))  //약관동의
        {   return "\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_USER_INSERT))  //회원가입
        {    return "\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_USER_AGREE_PRIVATE)) //개인 정보 취급 방침
        {    return "개인정보취급방침\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_USER_POINT_LIST)) //포인트 적립 리스트
        {    return "포인트적립내역\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_USER_DISCOUNT_LIST)) //할인 리스트
        {    return "통신비 할인 내역\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_USER_DISCOUNT_INSERT)) //할인 금액 신청
        {    return "통신비할인신청\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_INQUIRY_INSERT)) //1:1 문의 등록
        {   return "적립문의\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_ADVERTISE_LIST)) //충전소 목록
        {    return "참여적립\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_ADVERTISE_SELECT_CHARGING)) //광고 상세
        {    return "터치애드\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_TOUCHAD_MAIN)) //터치애드 메인
        {    return "터치애드\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_CARD_LIST)) //교통카드 관리
        {    return "교통카드 관리\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_USER_CONFIGURE)) //광고푸시설정
        {    return "터치애드 설정\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_BOARD_NOTICE_LIST)) //공지사항리스트
        {    return "터치애드 공지\(TAUtil.getServiceSuffix())" }
        if (url!.contains(TAConstants.WEBURL_BOARD_INFO)) //이용방법
        {    return "터치애드 이용방법\(TAUtil.getServiceSuffix())" }
        else
        {    return titleName ?? "" }
        
    }
    
    // MARK: - Private
    
    private func initWebView() {
        
        let config = WKWebViewConfiguration()
        
        let contentController = WKUserContentController()
        config.userContentController = contentController
        //contentController.add(self, name: "scriptHandler")
        contentController.add(self, name: "videoEnd")
        contentController.add(self, name: "videoClose")
        config.preferences = WKPreferences()
        config.preferences.javaScriptEnabled = true
        config.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        } else {
            // Fallback on earlier versions
        }
        /*let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=0.8, maximum-scale=0.8, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        contentController.addUserScript(script)*/
        
        webViewDelegate = TAWebViewDelegate(self)
        config.processPool = TAGlobalManager.sharedInstance.processPool
        webView = WKWebView(frame: CGRect(), configuration: config)
        webView.uiDelegate = webViewDelegate
        webView.navigationDelegate = webViewDelegate
        webView.scrollView.bounces = false
        webView.backgroundColor = .white
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        webView.layer.masksToBounds = true;
        webView.cornerRadius = 10
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        let width = self.view.frame.size.width * 0.05
        let height = self.view.frame.size.height * 0.05
        NSLayoutConstraint.activate([
        webView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: width),
        webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: height),
        webView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -1 * width),
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -1 * height)
        ])
        /*webView.snp.makeConstraints { (make) in
            if let titleView = self.titleContainerView {
                make.top.equalTo(titleView.snp.bottom).offset(60)
                make.left.equalTo(self.view).offset(20)
                make.right.equalTo(self.view).offset(-20)
                make.bottom.equalTo(self.view).offset(-60)
            }
        }*/
//        webView.snp.makeConstraints { (make) in
//
//            let width = self.view.frame.size.width * 0.05
//            let height = self.view.frame.size.height * 0.05
//
//            make.top.equalTo(self.view).offset(height)
//            make.left.equalTo(self.view).offset(width)
//            make.right.equalTo(self.view).offset(width * -1)
//            make.bottom.equalTo(self.view).offset(height * -1)
            
            
            /*if #available(iOS 11.0, *) {
                make.centerX.centerY.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.centerX.centerY.equalTo(self.view.center)
            }
            let width = self.view.frame.size.width * 0.9
            let height = self.view.frame.size.height * 0.9
            make.width.equalTo(width)
            make.height.equalTo(height)*/
//       }
        /*webView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.centerX.centerY.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.centerX.centerY.equalTo(self.view.center)
            }
            let width = self.view.frame.size.width * 0.9
            let height = self.view.frame.size.height * 0.9
            make.width.equalTo(width)
            make.height.equalTo(height)
        }*/
    }
    /*
    private func addAccessToken(_ url: String) -> String {
        /*if !url.contains("_token=") {
            if url.contains("?") {
                return url + "&_token=\(MCGlobalManager.sharedInstance.loginInfo?.accessToken ?? "")"
            } else {
                return url + "?_token=\(MCGlobalManager.sharedInstance.loginInfo?.accessToken ?? "")"
            }
        }*/
        
        return url
    }
    */
    /*private func setTitleName(_ str: String) {
        getTitleView()?.titleLabel.text = str
    }*/

    // MARK: - MCWebViewInterface
    
    /*func setTitleString(_ title: String) {
        setTitleName(title)
    }*/
    /*
    // MARK: - DO Action by push Notification
    func updateStatus<T: NSDictionary>( response : T?) {
        
        guard let dic = response else {
            return
        }
        if let returnMessage = dic["message"]
        {
            //제휴 서비스 등록 완료 알림 처리
            //delegateSelectMap?.allianceComplete(message: returnMessage as! String)
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func goPageFromDeepLink<T: NSString>(response : T?) {
        guard let url = response else {
            return
        }
        webView.backForwardList.perform(Selector(("_removeAllItems")))
        if let urlStr = URL(string: addAccessToken(url as String).getFullUrl())
        {
            webView.load(URLRequest(url: urlStr))
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    */
    @IBAction func backAction(_ sender: Any) {
        
        let urlObj = URL(string:TAConstants.URL_MOVIE_STOP)
        webView.load(URLRequest(url: urlObj!))
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        
        let urlObj = URL(string:TAConstants.URL_MOVIE_STOP)
        webView.load(URLRequest(url: urlObj!))
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: false, completion:{
            /*if self.openerViewController is MainViewController {
                if let mc = self.openerViewController as? MainViewController
                {
                    mc.viewWillAppear(false)
                }
            }*/
        //})
    
    }
    
    override func reloadWebView(){
        if let _ = self.webView.url
        {
            self.webView.reload()
        }
        else
        {
            self.goNavigationLink()
        }
    }
    
    func startPromptCommonPopupView(_ popupViewDic: [String: String]) {
        let title = popupViewDic["title"]
        let msg = popupViewDic["msg"]
        let ok = popupViewDic["ok"]
        let cancel = popupViewDic["cancel"]
        
        let textColor = UIColor.rgb(34, 34, 34)
        let textSize: CGFloat = 16.0
        
        PromptCommonPopupView.createView(self.view, title: title!, text: msg!, textColor: textColor, textSize: textSize, confirmText: ok!,
            confirmAction: {() in},
            cancelText: cancel!, cancelAction: {() in
                if let urlStr = self.webView.url?.absoluteString , urlStr.contains(TAConstants.WEBURL_ADVERTISE_SELECT)
                {
                    self.navigationController?.popViewController(animated: true)
                }
            })
    }
    
    func setTitleString(_ urlString: String)
    {
        /*url = urlString
        if let title = screenName() as String? {
            self.titleLabel?.text = title
            if title == ""
            {
                self.titleContainerView?.frame.size = CGSize(width:0, height:0)
            }
        }*/
        self.titleLabel?.text = urlString
    }
    
    func setNavigationStatus(_ urlString: String)
    {
        arrangeButtons(urlString)
    }
    
    private func arrangeButtons(_ urlString: String){
        
        titleContainerView?.isHidden = true
        
    }
    
}


extension PopupWebViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        //if(message.name == "stopIndicator") {
        //    self.stopIndicator()
        //}
        /*
        if(message.name == TAConstants.MESSAGE_HANDLER_NAME)
        {
            if let functionName = message.body as? String
            {
                if functionName == TAConstants.VIDEO_CLOSE_FUNCTION_NAME
                {
                    PromptCommonPopupView.createView(self.view, title: TAConstants.COMMON_POPUP_TITLE, text: TAConstants.ADVERTISE_VIDEO_EXIT_MESSAGE, textAlign: .center, confirmText: TAConstants.COMMON_CONTINUE_TITLE, confirmAction: {()in
                        
                    }, cancelText: TAConstants.COMMON_EXIT_TITLE, cancelAction: {()in
                        
                        self.dismissAction(message)
                        
                    })
                }
                else if functionName == TAConstants.VIDEO_END_FUNCTION_NAME
                {
                    self.dismissAction(message)
                }
            }
        }
        */
        if (message.name == TAConstants.VIDEO_CLOSE_FUNCTION_NAME)
        {
            PromptCommonPopupView.createView(self.view, title: TAConstants.COMMON_POPUP_TITLE, text: TAConstants.ADVERTISE_VIDEO_EXIT_MESSAGE, textAlign: .center, confirmText: TAConstants.COMMON_CONTINUE_TITLE, confirmAction: {()in
                
            }, cancelText: TAConstants.COMMON_EXIT_TITLE, cancelAction: {()in
                
                self.dismissAction(message)
                
            })
        }
        else if (message.name == TAConstants.VIDEO_END_FUNCTION_NAME)
        {
            self.dismissAction(message)
        }
    }

}
