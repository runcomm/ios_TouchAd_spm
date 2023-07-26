//
//  CommonWebViewController.swift
//  touchad
//
//  Created by shimtaewoo on 2020/08/19.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import WebKit
// import SnapKit
import AdSupport
import AppTrackingTransparency

class CommonWebViewController: BaseViewController, TAWebViewInterface {
    
    @IBOutlet weak var rightMenuButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var whiteBackButton: UIButton!
    @IBOutlet weak var blackBackButton: UIButton!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var exitButton: UIButton!
    
    var webView: WKWebView!
    private var webViewDelegate: TAWebViewDelegate?
    
    var titleName: String?
    var webViewConfiguration : WKWebViewConfiguration?
    //weak var delegateSelectMap : SelectMapProtocol?
    
    private var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove webview cache, apply for fixed page
        /*if let title = screenName() as String? {
            self.titleLabel?.text = title
            if title == ""
            {
                self.titleContainerView?.frame.size = CGSize(width:0, height:0)
            }
        }*/
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        initWebView()
        goNavigationLink()
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) {
            [unowned self] notification in
            // background에서 foreground로 돌아오는 경우 실행 될 코드
            if let vc = UIApplication.shared.keyWindow?.visibleViewController as? UIViewController {

                if let cwc = vc as? CommonWebViewController {
                    if let url = cwc.webView.url,
                        url.absoluteString.contains(TAConstants.WEBURL_TODAY_MONEY_VIEW) ||
                        url.absoluteString.contains(TAConstants.WEBURL_TODAY_BANNER_VIEW) ||
                        url.absoluteString.contains(TAConstants.WEBURL_TODAY_MAIN_VIEW)
                    {
                        if let currentUrl = url.updateExistence("adsId", value: TAUtil.getADID()).absoluteString as String?
                        {
                            printd("url : \(currentUrl)")
                            let script = "javascript:location.replace('\(currentUrl)');"
                            TAGlobalManager.evaluateJavascriptWebView(self, script:script)
                        }
                    }
                }
            }
            
//            if let currentUrl = self.webView?.url?.updateExistence("adsId", value: TAUtil.getADID()).absoluteString
//            {
//                printd("url : \(currentUrl)")
//                let script = "javascript:location.replace('\(currentUrl)');"
//                TAGlobalManager.evaluateJavascriptWebView(self, script:script)
//            }
            
            
        }

        
//        if #available(iOS 14.0, *) {
//
//            ATTrackingManager.requestTrackingAuthorization { (status) in
//                switch status {
//                    case .authorized:
//                        print("authorized")
//                        DispatchQueue.main.async {
//                            self.goNavigationLink()
//                        }
//                    default:
//                        DispatchQueue.main.async {
//                            TAGlobalManager.createPromptCommonPopupView(self, confirmAction: {() in
//                                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
//                                self.navigationController?.popViewController(animated: true)
//                            }, cancelAction: {() in
//                                self.navigationController?.popViewController(animated: true)
//                            })
//                        }
//                }
//            }
//        }
//        else
//        {
//            if (!ASIdentifierManager.shared().isAdvertisingTrackingEnabled)
//            {
//                DispatchQueue.main.async {
//                    TAGlobalManager.createPromptCommonPopupView(self, confirmAction: {() in
//                        UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
//                        self.navigationController?.popViewController(animated: true)
//                    }, cancelAction: {() in
//                        self.navigationController?.popViewController(animated: true)
//                    })
//                }
//            }
//            else
//            {
//                DispatchQueue.main.async {
//                    self.goNavigationLink()
//                }
//            }
//        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let urlStr = url, urlStr.contains(TAConstants.WEBURL_ADVERTISE_SELECT)
        {
            if let vc = UIApplication.shared.keyWindow?.visibleViewController as? UIViewController {

                if let cwc = vc as? CommonWebViewController {
                    if let urlStr = cwc.url
                    {
                        if urlStr.contains(TAConstants.WEBURL_TODAY_MONEY_VIEW) ||
                            urlStr.contains(TAConstants.WEBURL_TODAY_BANNER_VIEW) ||
                            urlStr.contains(TAConstants.WEBURL_TODAY_MAIN_VIEW)
                        {
                            cwc.reloadWebView()
                        }
                    }
                }
            }
        }
    }
    
    func startPromptCommonPopupView(_ popupViewDic: [String: String]) {
        let title = popupViewDic["title"]
        let msg = popupViewDic["msg"]
        let ok = popupViewDic["ok"]
        let cancel = popupViewDic["cancel"]
        
        var textColor = UIColor()
        var textSize: CGFloat = 0.0
        
        if let url = self.webView.url
        {
            let isQueryNameAndValue = url.isQueryItemNameAndValue(checkName: "platformId", checkValue: TAConstants.PLATFORM_ID_TODAY_EARNING)
            let urlStr = url.absoluteString
            
            if (urlStr.contains(TAConstants.WEBURL_ADVERTISE_SELECT) && isQueryNameAndValue)
            {
                textColor = UIColor.red
                textSize = 18.0
            }
            else
            {
                textColor = UIColor.rgb(34, 34, 34)
                textSize = 16.0
            }
        }
        
        PromptCommonPopupView.createView(self.view, title: title!, text: msg!, textColor: textColor, textSize: textSize, confirmText: ok!,
            confirmAction: {() in
                if let urlStr = self.webView.url?.absoluteString , urlStr.contains(TAConstants.WEBURL_INQUIRY_INSERT)
                {
                    self.webView.evaluateJavaScript("javascript:after_confirm();")
                }
            },
            cancelText: cancel!, cancelAction: {() in
                if let urlStr = self.webView.url?.absoluteString , urlStr.contains(TAConstants.WEBURL_ADVERTISE_SELECT){
                    self.navigationController?.popViewController(animated: true)
                }
            })
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        deleteUrlStackTouchAd()
//        printd("deleteUrlStackTouchAd = \(TAWebViewDelegate.urlStack)")
//    }

    //최상위 화면의 navigationController 상태와 CommonWebViewController 화면인지 체크하는 함수
    private func deleteUrlStackTouchAd() {
        if let vc = UIApplication.shared.keyWindow?.visibleViewController as? UIViewController {

            let cwc = vc as? CommonWebViewController
            if (self.navigationController != nil) {
                if (cwc == nil)
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
            
            //let notiToken = TAGlobalManager.deviceToken as String?
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
                urlStr.contains(TAConstants.WEBURL_TODAY_MONEY_VIEW) ||
                urlStr.contains(TAConstants.WEBURL_TODAY_BANNER_VIEW) ||
                urlStr.contains(TAConstants.WEBURL_TODAY_MAIN_VIEW)
                {
                    let urlObj = urlObj
                    //.appendingNonExistence("notiToken",value: notiToken)
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
                    
                    if urlStr.contains(TAConstants.WEBURL_ADVERTISE_LIST)
                    {
                        let urlObjAddBanner = urlObj.appendingNonExistence("bannerYn",value: bannerYn)
                        webView.load(URLRequest(url: urlObjAddBanner))
                    }
                    else
                    {
                        webView.load(URLRequest(url: urlObj))
                    }
                    
                }
                else if urlStr.contains(TAConstants.WEBURL_INQUIRY_INSERT)
                {
                    let urlObj = urlObj
                    .appendingNonExistence("mbrId",value: mbrId)
                    .appendingNonExistence("platformId",value: platformId)
                    .appendingNonExistence("comm",value: "Z")
                    .appendingNonExistence("os",value: TAConstants.OS)
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
            
            print("url!!! ==", urlStr)
            
            
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        NSLog("viewDidAppear")
    }
    
    // MARK: - Private
    
    private func arrangeButtons(_ urlString: String){
        
        if urlString.contains(TAConstants.WEBURL_ADVERTISE_LIST)
        {
            rightMenuButton.isHidden = true
            questionButton.isHidden = false
            questionButton.setTitleColor(UIColor.rgb(71, 55, 223), for: .normal)
            titleContainerView?.isHidden = false
            titleContainerView?.backgroundColor = .white
            webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: self.titleContainerView!.bottomAnchor),
                webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            ])
//            webView.snp.makeConstraints { (make) in
//                if let titleView = self.titleContainerView {
//                    make.top.equalTo(titleView.snp.bottom)
//                    make.left.equalTo(self.view)
//                    make.right.equalTo(self.view)
//                    make.bottom.equalTo(self.view)
//                }
//            }
            titleLabel?.textColor = UIColor.rgb(34,34,34)
            whiteBackButton?.isHidden = true
            blackBackButton?.isHidden = false
            bottomBorderView?.isHidden = false
            exitButton?.isHidden = true
        }
        else if urlString.contains(TAConstants.WEBURL_TODAY_MONEY_VIEW) ||
                urlString.contains(TAConstants.WEBURL_TODAY_BANNER_VIEW) ||
                urlString.contains(TAConstants.WEBURL_TODAY_MAIN_VIEW)
        {
            rightMenuButton.isHidden = true
            questionButton.isHidden = false
            questionButton.setTitleColor(UIColor.rgb(255, 255, 255), for: .normal)
            titleContainerView?.isHidden = false
            titleContainerView?.backgroundColor = UIColor.rgb(120,190,255)
            webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: self.titleContainerView!.bottomAnchor),
                webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            ])
//            webView.snp.makeConstraints { (make) in
//                if let titleView = self.titleContainerView {
//                    make.top.equalTo(titleView.snp.bottom)
//                    make.left.equalTo(self.view)
//                    make.right.equalTo(self.view)
//                    make.bottom.equalTo(self.view)
//                }
//            }
            titleLabel?.textColor = UIColor.rgb(255,255,255)
            whiteBackButton?.isHidden = false
            blackBackButton?.isHidden = true
            bottomBorderView?.isHidden = true
            exitButton?.isHidden = true
        }
        else if urlString.contains(TAConstants.WEBURL_TOUCHAD_MAIN)
        {
            rightMenuButton.isHidden = false
            questionButton.isHidden = true
            titleContainerView?.isHidden = false
            titleContainerView?.backgroundColor = UIColor.rgb(62, 18, 191)// .clear --> #3E12BF
            webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: self.view.topAnchor),
                webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            ])
//            webView.snp.makeConstraints { (make) in
//                    make.top.equalTo(self.view)
//                    make.left.equalTo(self.view)
//                    make.right.equalTo(self.view)
//                    make.bottom.equalTo(self.view)
//            }
            titleLabel?.textColor = .white
            whiteBackButton?.isHidden = false
            blackBackButton?.isHidden = true
            bottomBorderView?.isHidden = true
            exitButton?.isHidden = true
        }
        else if (urlString.contains(TAConstants.WEBURL_BOARD_INFO) || urlString.contains(TAConstants.WEBURL_APPRL_NO_LIST))
        {
            rightMenuButton.isHidden = true
            questionButton.isHidden = true
            titleContainerView?.isHidden = false
            titleContainerView?.backgroundColor = UIColor.rgb(108,25,189) //#6c19bd
            webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: self.titleContainerView!.bottomAnchor),
                webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            ])
//            webView.snp.remakeConstraints { (make) in
//                if let titleView = self.titleContainerView {
//                    make.top.equalTo(titleView.snp.bottom)
//                    make.left.equalTo(self.view)
//                    make.right.equalTo(self.view)
//                    make.bottom.equalTo(self.view)
//                }
//            }
            titleLabel?.textColor = .white
            whiteBackButton?.isHidden = false
            blackBackButton?.isHidden = true
            bottomBorderView?.isHidden = true
            exitButton?.isHidden = true
        }
        else
        {
            rightMenuButton.isHidden = true
            questionButton.isHidden = true
            titleContainerView?.isHidden = false
            titleContainerView?.backgroundColor = .white
            webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: self.titleContainerView!.bottomAnchor),
                webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            ])
//            webView.snp.remakeConstraints { (make) in
//                if let titleView = self.titleContainerView {
//                    make.top.equalTo(titleView.snp.bottom)
//                    make.left.equalTo(self.view)
//                    make.right.equalTo(self.view)
//                    make.bottom.equalTo(self.view)
//                }
//            }
            titleLabel?.textColor = UIColor.rgb(34,34,34)
            whiteBackButton?.isHidden = true
            blackBackButton?.isHidden = false
            bottomBorderView?.isHidden = false
            
            if urlString.contains(TAConstants.WEBURL_ADVERTISE_SELECT_CHARGING)
            {
                exitButton?.isHidden = false
            }
            else
            {
                exitButton?.isHidden = true
            }
        }
        
    }
    
    private func initWebView() {
        
        let config = WKWebViewConfiguration()
        
        let contentController = WKUserContentController()
        config.userContentController = contentController
        contentController.add(self, name: "stopIndicator")
        config.userContentController.add(self, name: "videoEnd")
        config.userContentController.add(self, name: "videoClose")
        config.preferences = WKPreferences()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        } else {
            // Fallback on earlier versions
        }
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        contentController.addUserScript(script)
        webViewDelegate = TAWebViewDelegate(self)
        config.processPool = TAGlobalManager.sharedInstance.processPool
        webView = (webViewConfiguration == nil) ?  WKWebView(frame: CGRect(), configuration: config)
            : WKWebView(frame: CGRect(), configuration: webViewConfiguration!)
        webView.uiDelegate = webViewDelegate
        webView.navigationDelegate = webViewDelegate
        webView.scrollView.bounces = false
        webView.backgroundColor = .white
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        //view.addSubview(webView)
        view.insertSubview(webView, belowSubview: titleContainerView!)
        /*
        webView.snp.makeConstraints { (make) in
            if let titleView = self.titleContainerView {
                make.top.equalTo(titleView.snp.bottom)
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
        }
         */
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
    }*/
    
    /*private func setTitleName(_ str: String) {
        getTitleView()?.titleLabel.text = str
    }*/

    // MARK: - MCWebViewInterface
    
    /*func setTitleString(_ title: String) {
        setTitleName(title)
    }*/
    
    // MARK: - DO Action by push Notification
    /*func updateStatus<T: NSDictionary>( response : T?) {
        
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
    }*/
    
    @IBAction func backAction(_ sender: Any) {
        
        if let urlStr = self.webView.url?.absoluteString
        {
            if urlStr.contains(TAConstants.WEBURL_ADVERTISE_LIST)
            {
                TAGlobalManager.platformId = TAConstants.PLATFORM_ID_TODAY_EARNING
                self.navigationController?.popViewController(animated: true)
            }
            else if urlStr.contains(TAConstants.WEBURL_TODAY_MONEY_VIEW) ||
                    urlStr.contains(TAConstants.WEBURL_TODAY_BANNER_VIEW) ||
                    urlStr.contains(TAConstants.WEBURL_TODAY_MAIN_VIEW)
            {
                self.navigationController?.popViewController(animated: true)
            }
            else if urlStr.contains(TAConstants.WEBURL_ADVERTISE_SELECT)
            {
                let script = "javascript:closeAdvertise();"
                webView.evaluateJavaScript(script)
                //self.navigationController?.popViewController(animated: true)
            }
            else if urlStr.contains(TAConstants.WEBURL_ADVERTISE_SELECT_CHARGING)
            {
                self.navigationController?.popViewController(animated: true)
            }
            else if urlStr.contains(TAConstants.WEBURL_BOARD_NOTICE_LIST)
            {
                if (self.navigationController != nil)
                {
                    let vcs: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    
                    if vcs.count >= 2 , let vc = vcs[vcs.count - 2] as? CommonWebViewController
                    {
                        if ((vc.webView.url?.absoluteString.contains(TAConstants.WEBURL_TOUCHAD_MAIN)) != nil)
                        {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else
                    {
                        self.url = TAConstants.WEBURL_TOUCHAD_MAIN
                        self.goNavigationLink()
                    }
                }
                else
                {
                    self.url = TAConstants.WEBURL_TOUCHAD_MAIN
                    self.goNavigationLink()
                }
            }
            else if urlStr.contains(TAConstants.WEBURL_BOARD_NOTICE_SELECT)
            {
                self.url = TAConstants.WEBURL_BOARD_NOTICE_LIST
                self.goNavigationLink()
            }
            else if urlStr.contains(TAConstants.WEBURL_BOARD_FAQ_LIST)
            {
                self.webView.goBack()
            }
            else if urlStr.contains(TAConstants.WEBURL_BOARD_FAQ_SELECT)
            {
                self.webView.goBack()
            }
            else if urlStr.contains(TAConstants.WEBURL_INQUIRY_INSERT)
            {
                if (self.webView.canGoBack)
                {
                    self.webView.goBack()
                }
                else
                {
                    self.webView.goBackToFirstItemInHistory()
                }
            }
            else
            {
                if (self.webView.canGoBack)
                {
                    self.webView.goBackToFirstItemInHistory()
                }
                else
                {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
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
    
    override func goBack(depth: Int, webUrlStr: String?) {
        if (self.navigationController != nil)
        {
            let vcs: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            
            if vcs.count >= depth , let vc = vcs[vcs.count - depth] as? CommonWebViewController
            {
                if let url = vc.webView.url
                {
                    if url.absoluteString.contains(webUrlStr ?? "")
                    {
                        vc.reloadWebView()
                    }
                    
                }
            }
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func detachPopupView() {
        //self.webViewPopup.removeLast()
        if let view = view.viewWithTag(9990)
        {
            view.removeFromSuperview()
        }
    }
    
    func attachPopupView(child: UIViewController)
    {
        let containerView = UIView()
        containerView.tag = 9990
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
               containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
               containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
               containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
               ])
        
        addChild(child)
        child.didMove(toParent: self)
        child.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        child.view.frame = containerView.bounds
        containerView.addSubview(child.view)
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
    
    @IBAction func rightMenuAction(_ sender: UIButton) {
        NSLog("rightMenuAction")
        //TAGlobalManager.pushCommonWebViewController(self, url: TAConstants.WEBURL_USER_CONFIGURE)
        url = TAConstants.WEBURL_USER_CONFIGURE
        goNavigationLink()
    }
    
    @IBAction func questionAction(_ sender: UIButton) {
        NSLog("questionAction")
        //TAGlobalManager.pushCommonWebViewController(self, url: TAConstants.WEBURL_INQUIRY_INSERT)
        //url = TAConstants.WEBURL_INQUIRY_INSERT
        //goNavigationLink()
        
        //오늘의 적립 페이지에서 적립문의 터치 시 약관동의 상태를 체크하기위해 차장님과 협의하여 코드 수정
        let script = "javascript:checkUserAgree();"
        webView.evaluateJavaScript(script)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        
        let urlObj = URL(string:TAConstants.URL_MOVIE_STOP)
        webView.load(URLRequest(url: urlObj!))
        self.navigationController?.popViewController(animated: true)
    }
}


extension CommonWebViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        if(message.name == "stopIndicator") {
            self.stopIndicator()
        }
        else if (message.name == TAConstants.VIDEO_CLOSE_FUNCTION_NAME)
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
        /*
        else if(message.name == TAConstants.MESSAGE_HANDLER_NAME)
        {
            if let functionName = message.body as? String
            {
                if functionName == TAConstants.VIDEO_CLOSE_FUNCTION_NAME
                {
                    PromptCommonPopupView.createView(self.view, title: TAConstants.COMMON_POPUP_TITLE, text: TAConstants.ADVERTISE_VIDEO_EXIT_MESSAGE, textAlign: .center, confirmText: TAConstants.COMMON_CONTINUE_TITLE, confirmAction: {()in
                        
                    }, cancelText: TAConstants.COMMON_EXIT_TITLE, cancelAction: {()in
                        
                        self.backAction(message)
                        
                    })
                }
                else if functionName == TAConstants.VIDEO_END_FUNCTION_NAME
                {
                    self.backAction(message)
                }
            }
        }
        */
    }

}
