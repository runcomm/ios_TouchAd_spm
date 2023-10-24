//
//  TAGlobalManager.swift
//  touchad
//
//  Created by shimtaewoo on 2020/08/31.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import WebKit
//import Firebase
import CoreTelephony
//import JWTDecode
import AdSupport
import AppTrackingTransparency

class TAGlobalManager: NSObject {
    
    static private let KEY_DEVICE_TOKEN = "KEY_DEVICE_TOKEN"
    static private let KEY_ADVERTISE_ID = "KEY_ADVERTISE_ID"
    static private let KEY_USER_INFO = "KEY_USER_INFO"
    static private let KEY_TOUCHAD = "touchad"
    static private let KEY_CONGRATULATE = "KEY_CONGRATULATE"
    static private let KEY_MBR_ID = "KEY_MBR_ID"
    static private let KEY_PLATFORM_ID = "KEY_PLATFORM_ID"
    static private let KEY_ACCESS_TOKEN = "KEY_ACCESS_TOKEN"
    static private let KEY_ADVERTISE_PUSH = "KEY_ADVERTISE_PUSH"
    static private let KEY_GENDER = "KEY_GENDER"
    static private let KEY_BIRTH_YEAR = "KEY_BIRTH_YEAR"
    static private let KEY_BANNER_YN = "KEY_BANNER_YN"
    static private let KEY_IS_APP_PUSH = "KEY_IS_APP_PUSH"
    static private let KEY_IS_TRAFFIC_PUSH = "KEY_IS_TRAFFIC_PUSH"
    static private let KEY_IS_NOT_FIRST_OPEN = "KEY_IS_NOT_FIRST_OPEN"
    static private let KEY_IS_PROD = "KEY_IS_PROD"
    
    //static private var mMbrId: String = ""
    //static private var mPlatformId: String = ""
    
    static let sharedInstance = TAGlobalManager()
    
    // devicetoken
    static var deviceToken: String {
        get {
            return UserDefaults.standard.string(forKey: KEY_DEVICE_TOKEN) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_DEVICE_TOKEN)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isProd: Bool {
        get {
            return UserDefaults.standard.bool(forKey: KEY_IS_PROD)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_IS_PROD)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var mbrId: String {
        get {
            return UserDefaults.standard.string(forKey: KEY_MBR_ID) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_MBR_ID)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var platformId: String {
        get {
            return UserDefaults.standard.string(forKey: KEY_PLATFORM_ID) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_PLATFORM_ID)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: KEY_ACCESS_TOKEN) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_ACCESS_TOKEN)
            UserDefaults.standard.synchronize()
        }
    }
    
    // login userinfo
    static var userInfo: [String : Any] {
        get {
            return UserDefaults.standard.dictionary(forKey: KEY_USER_INFO) ?? [String : Any]()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_USER_INFO)
            UserDefaults.standard.synchronize()
        }
    }
 
    // login userinfo
    static var touchad: String {
        get {
            return UserDefaults.standard.string(forKey: KEY_TOUCHAD) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_TOUCHAD)
            UserDefaults.standard.synchronize()
        }
    }

    // congratulateYn
    static var congratulateYn: String {
        get {
            return UserDefaults.standard.string(forKey: KEY_CONGRATULATE) ?? "N"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_CONGRATULATE)
            UserDefaults.standard.synchronize()
        }
    }

    // adPushYn
    static var adPushYn: String {
        get {
            return UserDefaults.standard.string(forKey: KEY_ADVERTISE_PUSH) ?? "N"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_ADVERTISE_PUSH)
            UserDefaults.standard.synchronize()
        }
    }
    
    // gender
    static var gender: String {
        get {
            return UserDefaults.standard.string(forKey: KEY_GENDER) ?? "2"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_GENDER)
            UserDefaults.standard.synchronize()
        }
    }
    
    // birthYear
    static var birthYear: String {
        get {
            return UserDefaults.standard.string(forKey: KEY_BIRTH_YEAR) ?? "1992"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_BIRTH_YEAR)
            UserDefaults.standard.synchronize()
        }
    }
    
    // bannerYn
    static var bannerYn: String {
        get {
            return UserDefaults.standard.string(forKey: KEY_BANNER_YN) ?? "N"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_BANNER_YN)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isAppPush: Bool {
        get {
            return UserDefaults.standard.bool(forKey: KEY_IS_APP_PUSH)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_IS_APP_PUSH)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isAdPush: Bool {
        get {
            return UserDefaults.standard.bool(forKey: KEY_IS_TRAFFIC_PUSH)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_IS_TRAFFIC_PUSH)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isNotFirstOpen: Bool {
        get {
            return UserDefaults.standard.bool(forKey: KEY_IS_NOT_FIRST_OPEN)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_IS_NOT_FIRST_OPEN)
            UserDefaults.standard.synchronize()
        }
    }
    
    // 딥링크 이동
    class func goDeepLink(_ parent: UIViewController, deepLink: String?, options: [String: Any]? = nil) {
        if let dic = deepLink?.parseScheme() {
            
            if dic["scheme"] == TAConstants.DEEPLINK_JS_PREFIX
            {
                switch dic["command"] {
                case "login_complete":
                    NSLog("login_complete") //usrIdx=30
                    let usrIdx = dic["usrIdx"] as String?
                    let isReload = dic["isReload"] as String?
                    let accessToken = dic["accessToken"] as String?
                    TAGlobalManager.accessToken = accessToken ?? ""
                    NetworkRequest.requestUserInfo(nil, usrIdx: usrIdx, mbrId: nil, success: { (response) in
                        //self.stopIndicator()
                        if let user = response.data?[0] as User? {
                            
                            TAGlobalManager.userInfo = user.toJSON()
                            if isReload == "true"
                            {
                                TAGlobalManager.reloadWebViewController(parent)
                            }
                            /*if let storyboard = parent.storyboard
                            {
                                let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                                parent.navigationController?.pushViewController(viewController, animated: true)
                            }*/
                            
                        }
                    }, failure: { (response, error, isProcess) in
                        //self.stopIndicator()
                        //NetworkManager.sharedInstance.defaultFailFunc(nil, response: response, error: error, isProcess: isProcess)
                        if let vc = parent as? BaseViewController
                        {
                            NetworkManager.sharedInstance.defaultFailFunc(vc, response: response, error: error, isProcess: isProcess)
                        }
                        else
                        {
                            CommonPopupView.createView(parent.view, title: TAConstants.COMMON_POPUP_TITLE, text: response?.error ??  TAConstants.SERVER_ERROR_MESSAGE, confirmText: TAConstants.COMMON_CONFIRM_TITLE, confirmAction: {() in })
                        }
                        
                    })
                case "start_loading":
                    NSLog("start_loading") //start indicator
                    if let vc = parent as? BaseViewController
                    {
                        vc.startIndicator()
                    }
                case "stop_loading":
                    NSLog("stop_loading") //start indicator
                    if let vc = parent as? BaseViewController
                    {
                        vc.stopIndicator()
                    }
                case "signout_complete":
                    NSLog("signout_complete")
                    parent.navigationController?.popToRootViewController(animated: true)
                    TAGlobalManager.userInfo = [String:Any]()
                    //parent.navigationController?.popToRootViewController(animated: true)
                    UIApplication.shared.unregisterForRemoteNotifications()
                    TAGlobalManager.pushCommonWebViewController(parent, url: TAConstants.WEBURL_LOGIN)
                case "logout":
                    NSLog("logout")
                    TAGlobalManager.userInfo = [String:Any]()
                    //parent.navigationController?.popToRootViewController(animated: true)
                    UIApplication.shared.unregisterForRemoteNotifications()
                    TAGlobalManager.pushCommonWebViewController(parent, url: TAConstants.WEBURL_LOGIN)
                case "set_user_info":
                    NSLog("set_user_info")
                    let usrIdx = String(TAGlobalManager.userInfo["usr_idx"] as! Int)
                    NetworkRequest.requestUserInfo(nil, usrIdx: usrIdx, mbrId: nil, success: { (response) in
                        //self.stopIndicator()
                        if let user = response.data?[0] as User? {
                            
                            TAGlobalManager.userInfo = user.toJSON()
                            TAGlobalManager.reloadWebViewController(parent)
                            
                        }
                    }, failure: { (response, error, isProcess) in
                        //self.stopIndicator()
                        //NetworkManager.sharedInstance.defaultFailFunc(nil, response: response, error: error, isProcess: isProcess)
                        if let vc = parent as? BaseViewController
                        {
                            NetworkManager.sharedInstance.defaultFailFunc(vc, response: response, error: error, isProcess: isProcess)
                        }
                        else
                        {
                            CommonPopupView.createView(parent.view, title: TAConstants.COMMON_POPUP_TITLE, text: response?.error ??  TAConstants.SERVER_ERROR_MESSAGE, confirmText: TAConstants.COMMON_CONFIRM_TITLE, confirmAction: {() in })
                        }
                    })
                case "modal_close":
                    NSLog("modal_close")
                    if let pwc = parent as? PopupWebViewController
                    {
                        //parent.dismiss(animated: false, completion: nil)
                        pwc.navigationController?.popViewController(animated: true)
                    }
                    else if let cwc = parent as? CommonWebViewController
                    {
                        //parent.navigationController?.popViewController(animated: true)
                        cwc.goBack(depth: 2, webUrlStr: TAConstants.WEBURL_TOUCHAD_MAIN)
                    }
                case "go_url":
                    NSLog("go_url")
                    if let target = dic["target"] as String?
                    {
                        if target == "browser"
                        {
                            /*
                            if let linkUrl = dic["url"]?.urlDecode() {
                                                            
                                if let url = URL(string: linkUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                                {
                                    if #available(iOS 10.0, *) {
                                        NSLog("url : \(url)")
                                        UIApplication.shared.open(url)
                                    } else {
                                        NSLog("url : \(url)")
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                                else
                                {
                                    NSLog("Url address has a problem")
                                }
                            }
                            */
                            if let linkUrl = dic["url"]?.urlDecode(), let url = URL(string: linkUrl) {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                        }
                        else if target == "inapp"
                        {
                            if let url = dic["url"]?.urlDecode() {
                                if parent is PopupWebViewController
                                {
                                    let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
                                    /*let pvc = PopupWebViewController(nibName: "PopupWebViewController", bundle: bundle)
                                    pvc.url = url
                                    //pvc.transitioningDelegate = parent as! UIViewControllerTransitioningDelegate
                                    //pvc.modalPresentationStyle = .custom
                                    pvc.openerViewController = parent
                                    parent.present(pvc, animated: false, completion: nil)*/
                                    
                                    let cvc = PopupWebViewController(nibName: "PopupWebViewController", bundle: Bundle.module)
                                    //cvc.titleName = "TOUCHAD"
                                    cvc.url = url
                                    //pvc.transitioningDelegate = parent as! UIViewControllerTransitioningDelegate
                                    //pvc.modalPresentationStyle = .custom
                                    //cvc.openerViewController = parent
                                    parent.navigationController?.pushViewController(cvc, animated: true)
                                }
                                else if parent is CommonWebViewController
                                {
                                    let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
                                    let cvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: Bundle.module)
                                    cvc.titleName = "TOUCHAD"
                                    cvc.url = url
                                    //pvc.transitioningDelegate = parent as! UIViewControllerTransitioningDelegate
                                    //pvc.modalPresentationStyle = .custom
                                    //cvc.openerViewController = parent
                                    if (url.contains(TAConstants.WEBURL_ADVERTISE_LIST))
                                    {
                                        TAGlobalManager.platformId = TAConstants.PLATFORM_ID_EARNING
                                    }
                                    parent.navigationController?.pushViewController(cvc, animated: true)
                                    //parent.present(cvc, animated: false, completion: nil)
                                }
                            }
                        }
                    }
                case "refresh_token":
                    NSLog("refresh_token")
                    let accessToken = TAGlobalManager.accessToken
                    if accessToken == ""
                    {
                        let platformId = TAGlobalManager.platformId
                        let mbrId = TAGlobalManager.mbrId
                        NetworkRequest.requestJWTGenerate(nil, mbrId: mbrId, platformId: platformId, success: { (response) in
                            if let user = response.data?[0] as User? {

                                TAGlobalManager.accessToken = user.accessToken ?? ""
                                let script = "javascript:sendAccessToken('\(TAGlobalManager.accessToken)');"
                                evaluateJavascriptWebView(parent, script:script)
                            }
                        }, failure: { (response, error, isProcess) in
                            //NetworkManager.sharedInstance.defaultFailFunc(nil, response: response, error: error, isProcess: isProcess)
                            if let vc = parent as? BaseViewController
                            {
                                NetworkManager.sharedInstance.defaultFailFunc(vc, response: response, error: error, isProcess: isProcess)
                            }
                            else
                            {
                                CommonPopupView.createView(parent.view, title: TAConstants.COMMON_POPUP_TITLE, text: response?.error ??  TAConstants.SERVER_ERROR_MESSAGE, confirmText: TAConstants.COMMON_CONFIRM_TITLE, confirmAction: {() in })
                            }
                            
                        })
                    }
                    else
                    {
                        do {
                            let claims = try decode(jwt: accessToken)
                            print(claims)
                            //if claims.expired
                            //{
                                let platformId = TAGlobalManager.platformId
                                let mbrId = TAGlobalManager.mbrId
                                NetworkRequest.requestJWTRefresh(nil, mbrId: mbrId, platformId: platformId, success: { (response) in
                                    if let user = response.data?[0] as User? {

                                        TAGlobalManager.accessToken = user.accessToken ?? ""
                                        let script = "javascript:sendAccessToken('\(TAGlobalManager.accessToken)');"
                                        evaluateJavascriptWebView(parent, script:script)
                                    }
                                }, failure: { (response, error, isProcess) in
                                    if let vc = parent as? BaseViewController
                                    {
                                        NetworkManager.sharedInstance.defaultFailFunc(vc, response: response, error: error, isProcess: isProcess)
                                    }
                                    else
                                    {
                                        CommonPopupView.createView(parent.view, title: TAConstants.COMMON_POPUP_TITLE, text: response?.error ?? TAConstants.SERVER_ERROR_MESSAGE, confirmText: TAConstants.COMMON_CONFIRM_TITLE, confirmAction: {() in })
                                    }
                                })
                            //}
                            //else
                            //{
                            //    let script = "javascript:sendAccessToken('\(accessToken)');"
                            //    evaluateJavascriptWebView(parent, script:script)
                            //}
                        } catch {
                          print("Failed to decode JWT: \(error)")
                        }
                    }
                case "get_subway_real_time":
                    NSLog("get_subway_real_time")
                    
                    let name = dic["name"] ?? "서울"
                    
                    NetworkRequest.requestArrivalRealtime(nil, name: name, success: {
                        (response) in
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                            let str = String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "{}"
                            let script = "javascript:setStationRealTime(\(str));"
                            evaluateJavascriptWebView(parent, script:script)
                            
                        }catch let error as NSError {
                            
                            NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: error, isProcess: true)
                        
                        }
                        
                    }, failure: {(response, error, isProcess) in
                        
                        NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: error, isProcess: isProcess)
                        
                    })
                case "get_dust_weather_real_time":
                    NSLog("get_dust_weather_real_time")
                    //touchadjs://get_dust_weather_real_time?lat=37.89233400&lon=127.05571600&gridLat=61&gridLat=134
                    let lat = dic["lat"] ?? "0.0"
                    let lon = dic["lon"] ?? "0.0"
                    let gridLat = dic["gridLat"] ?? "0"
                    let gridLon = dic["gridLon"] ?? "0"
                    let in_pt = GeoTransPoint(Double(lon)!, Double(lat)!)
                    let tm_pt = GeoTrans.sharedInstance.convert(GeoTrans.GEO, GeoTrans.TM, in_pt)
                    var dataObject = [String:Any]()
                    //ret["result"] = 1
                    NetworkRequest.requestDustStation(nil, tmX: "\(tm_pt.x)", tmY: "\(tm_pt.y)", success: {
                        (response) in
                        do {
                            if response.count > 0
                            {
                                let dustStation : [String : Any] = response[0]
                                let stationName = dustStation["stationName"] as! String
                                NetworkRequest.requestDustInfo(nil, stationName: stationName, success: {
                                    (response) in
                                    do {
                                        if response.count > 0
                                        {
                                            let dustObj : [String : Any] = response[0]
                                            var dustInfo = [String:Any]()
                                            dustInfo["dustObj"] = dustObj
                                            dataObject["dustInfo"] = dustInfo
                                            
                                            let dateFormatter = DateFormatter()
                                            let oneHourAgo = NSDate(timeIntervalSinceNow: -3600)
                                            dateFormatter.dateFormat = "yyyyMMdd HH00"
                                            let result = dateFormatter.string(from: oneHourAgo as Date)
                                            let arr =  result.components(separatedBy: " ")
                                            
                                            NetworkRequest.requestWeatherInfo(nil, baseDate: arr[0], baseTime: arr[1], nx: gridLat, ny: gridLon, success: {
                                                (response) in
                                                do {
                                                    if response.count > 0
                                                    {
                                                        let skyObj = objectforKeyValue(response,key:"category",value:"SKY")
                                                        let t1hObjs = objectsforKeyValue(response,key:"category",value:"T1H")
                                                        let t1hObjBefore = t1hObjs[0]
                                                        
                                                        let dateFormatter = DateFormatter()
                                                        dateFormatter.dateFormat = "HH00"
                                                        let timeStr = dateFormatter.string(from: Date())
                                                        let t1hObjNow = objectforKeyValue(t1hObjs,key:"fcstTime",value:timeStr)
                                                        let compareValue = Int(t1hObjNow["fcstValue"] as! String)! - Int(t1hObjBefore["fcstValue"] as! String)!
                                                        
                                                        var weatherInfo = [String:Any]()
                                                        weatherInfo["skyObj"] = skyObj
                                                        weatherInfo["t1hObj"] = t1hObjNow
                                                        weatherInfo["compareValue"] = compareValue
                                                        dataObject["weatherInfo"] = weatherInfo
                                                        var ret = [String:Any]()
                                                        ret["result"] = 1
                                                        ret["error"] = ""
                                                        ret["data"] = [dataObject]
                                                        
                                                        do {
                                                            
                                                            let jsonData = try JSONSerialization.data(withJSONObject: ret, options: .prettyPrinted)
                                                            let str = String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "{}"
                                                            let script = "javascript:setDustWeatherRealTime(\(str));"
                                                            evaluateJavascriptWebView(parent, script:script)
                                                            
                                                        }catch let error as NSError {
                                                            
                                                            NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: error, isProcess: true)
                                                        
                                                        }
                                                        
                                                    }
                                                    else
                                                    {
                                                        NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: nil, isProcess: true)
                                                    }
                                                    
                                                }catch let error as NSError {
                                                    
                                                    NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: error, isProcess: true)
                                                
                                                }
                                                
                                            }, failure: {(response, error, isProcess) in
                                                
                                                NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: error, isProcess: isProcess)
                                                
                                            })
                                            
                                        }
                                        else
                                        {
                                            NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: nil, isProcess: true)
                                        }
                                        
                                    }catch let error as NSError {
                                        
                                        NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: error, isProcess: true)
                                    
                                    }
                                    
                                }, failure: {(response, error, isProcess) in
                                    
                                    NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: error, isProcess: isProcess)
                                    
                                })
                            }
                            else
                            {
                                NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: nil, isProcess: true)
                            }
                            
                        }catch let error as NSError {
                            
                            NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: error, isProcess: true)
                        
                        }
                        
                    }, failure: {(response, error, isProcess) in
                        
                        NetworkManager.sharedInstance.defaultFailFunc(nil, response: nil, error: error, isProcess: isProcess)
                        
                    })
                case "alert":
                    NSLog("alert")
                    
                    if let vc = parent as? BaseViewController
                    {
                        vc.stopIndicator()
                    }
                    
                    let title = dic["title"]?.urlDecode() ?? TAConstants.COMMON_POPUP_TITLE
                    let msg = dic["msg"]?.urlDecode() ?? TAConstants.COMMON_POPUP_MESSAGE
                    let ok = dic["ok"]?.urlDecode() ?? TAConstants.COMMON_CONFIRM_TITLE
                    
                    CommonPopupView.createView(parent.view, title: title, text: msg, confirmText: ok, confirmAction: {() in
                        if let wc = parent as? CommonWebViewController
                        {
                            if let urlStr = wc.webView.url?.absoluteString , urlStr.contains(TAConstants.WEBURL_CARD_LIST)
                            {
                                
                            }
                            else if let urlStr = wc.webView.url?.absoluteString , urlStr.contains(TAConstants.WEBURL_INQUIRY_INSERT) ,
                                    msg == TAConstants.INQUIRY_SUCCESS_MESSAGE
                            {
                                wc.webView.goBackToFirstItemInHistory()
                            }
                        }
                        else if let pwc = parent as? PopupWebViewController
                        {
                            
                        }
                    })
                    
                case "confirm":
                    NSLog("confirm")
                    
                    if let vc = parent as? BaseViewController
                    {
                        vc.stopIndicator()
                    }
                    
                    var popupViewDic = [String: String]()
                    popupViewDic["title"] = dic["title"]?.urlDecode() ?? TAConstants.COMMON_POPUP_TITLE
                    popupViewDic["msg"] = dic["msg"]?.urlDecode() ?? TAConstants.COMMON_POPUP_MESSAGE
                    popupViewDic["ok"] = dic["ok"]?.urlDecode() ?? TAConstants.COMMON_CONFIRM_TITLE
                    popupViewDic["cancel"] = dic["cancel"]?.urlDecode() ?? TAConstants.COMMON_CANCEL_TITLE
                    
                    if let wvc = parent as? CommonWebViewController
                    {
                        wvc.startPromptCommonPopupView(popupViewDic)
                    }
                    else if let pwvc = parent as? PopupWebViewController
                    {
                        pwvc.startPromptCommonPopupView(popupViewDic)
                    }
                
                case "ios_config":
                    if let wvc = parent as? CommonWebViewController
                    {
                        if #available(iOS 14.0, *) {
                                    
                            ATTrackingManager.requestTrackingAuthorization { (status) in
                                switch status {
                                    case .authorized:
                                        print("authorized")
                                        DispatchQueue.main.async {
                                            if let currentUrl = wvc.webView?.url?.updateExistence("adsId", value: TAUtil.getADID()).absoluteString
                                            {
                                                printd("url : \(currentUrl)")
                                                let script = "javascript:location.replace('\(currentUrl)');"
                                                TAGlobalManager.evaluateJavascriptWebView(wvc, script:script)
                                            }
                                        }
                                    default:
                                        DispatchQueue.main.async {
                                            TAGlobalManager.createPromptCommonPopupView(parent, confirmAction: {() in
                                                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                                                //parent.navigationController?.popViewController(animated: true)
                                            }, cancelAction: {() in
                                                //parent.navigationController?.popViewController(animated: true)
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
                                    TAGlobalManager.createPromptCommonPopupView(parent, confirmAction: {() in
                                        UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                                        //parent.navigationController?.popViewController(animated: true)
                                    }, cancelAction: {() in
                                        //parent.navigationController?.popViewController(animated: true)
                                    })
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    if let currentUrl = wvc.webView?.url?.updateExistence("adsId", value: TAUtil.getADID()).absoluteString
                                    {
                                        printd("url : \(currentUrl)")
                                        let script = "javascript:location.replace('\(currentUrl)');"
                                        TAGlobalManager.evaluateJavascriptWebView(wvc, script:script)
                                    }
                                }
                            }
                        }
                    }
                default:
                    break
                }
            }
            else if dic["scheme"] == TAConstants.DEEPLINK_PREFIX
            {
                if let url = deepLink?.replacingOccurrences(of: TAConstants.DEEPLINK_PREFIX + "://", with: "https://").replacingOccurrences(of: TAConstants.REAL_SERVER_BASE_URL, with: TAConstants.DEV_SERVER_BASE_URL)
                {
                    let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
                    let vc = PopupWebViewController(nibName: "PopupWebViewController", bundle: Bundle.module)
                    vc.url = url
                    //vc.modalPresentationStyle = .overFullScreen
                    /*
                    vc.transitioningDelegate = parent as? UIViewControllerTransitioningDelegate
                    vc.modalPresentationStyle = .custom
                    vc.openerViewController = parent
                    parent.present(vc, animated: true, completion: nil)
                    */
                    //let navController = UINavigationController(rootViewController: vc)
                    //navController.navigationBar.isHidden = true
                    //navController.modalPresentationStyle = .custom
                    //parent.present(navController, animated:true, completion: nil)
                    parent.navigationController?.pushViewController(vc, animated: true)
                }
            
            }
        }
    }
    
    class func createPromptCommonPopupView(_ parent: UIViewController, confirmAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        let boldMessage = TAConstants.IDFA_EARNING_MENU + TAConstants.IDFA_ALERT_MESSAGE_BOLD
        let firstString = NSMutableAttributedString(string: boldMessage, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        let secondString = NSAttributedString(string: TAConstants.IDFA_ALERT_MESSAGE_REGULAR_1)
        let thirdString = NSAttributedString(string: TAConstants.IDFA_ALERT_MESSAGE_REGULAR_2)

        firstString.append(secondString)
        
        PromptCommonPopupView.createView(parent.view, title: TAConstants.COMMON_POPUP_TITLE, attributeText: firstString, confirmText: TAConstants.COMMON_SETTING_TITLE, confirmAction: confirmAction, cancelText: TAConstants.COMMON_EXIT_TITLE, cancelAction: cancelAction)
    }
    
    // 공통 웹뷰 호출
    class func pushCommonWebViewController(_ parent: UIViewController, title: String? = nil, url: String?)
    {
            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
            let vc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
            vc.titleName = title
            vc.url = url
            parent.navigationController?.pushViewController(vc, animated: true)
    }

    // 공통 웹뷰 호출
    class func reloadWebViewController(_ parent: UIViewController) {

        /*if let className = parent.navigationController?.topViewController?.simpleClassName
        {
            NSLog("reloadCommonWebViewController : %@ ", className )
            if className == "CommonWebViewController"
            {
                let vc = parent.navigationController!.topViewController as! CommonWebViewController
                vc.reloadWebView()
            }
        }
        */
        let className = parent.simpleClassName
        
        if className == "CommonWebViewController" || className == "PopupWebViewController"
        {
           let vc = parent as! BaseViewController
           vc.reloadWebView()
        }
    }

    // 공통 웹뷰 호출
    class func navigationWebViewController(_ parent: UIViewController, url: String) {
        
       if let vc = parent as? BaseViewController
       {
            vc.url = url
            vc.goNavigationLink()
       }
        
    }
    
    // 로그아웃 이메일, 휴대폰, 비밀번호 삭제
    class func logout(parent: UIViewController? = nil, isMoveToLogin: Bool = false) {
        /*email = ""
        myPhoneNumber = ""
        password = ""
        
        if isMoveToLogin {
            if let storyboard = parent?.storyboard {
                let vc = storyboard.instantiateViewController(withIdentifier: "SplashViewController")
                
                parent?.navigationController?.setViewControllers([vc], animated: true)
            }
        }*/
    }

    class func displayCarrierInformation() {
        let netinfo = CTTelephonyNetworkInfo()
        if #available(iOS 12.0, *) {
            if let carrier = netinfo.serviceSubscriberCellularProviders?.first?.value
            { print("Carrier Name: \(carrier.carrierName!)\nCountryCode : \(carrier.mobileCountryCode!)\nNetworkCode: \(carrier.mobileNetworkCode!)\nisoCountryCode: \(carrier.isoCountryCode!)\nallowsVOIP: \(carrier.allowsVOIP)")
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    lazy var processPool = WKProcessPool()
    
    // iOS 검수를 위해 유동 도메인 설정
    var baseUrl: String?
    
    class func evaluateJavascriptWebView(_ parent: UIViewController , script: String? = nil) {
        
        if let cvc = parent as? CommonWebViewController
        {
            cvc.webView.evaluateJavaScript(script ?? "")
        }
        if let pvc = parent as? PopupWebViewController
        {
            pvc.webView.evaluateJavaScript(script ?? "")
        }
    }
    
    // [[String:Any]]
    class func objectsforKeyValue(_ target : [[String:Any]], key : String, value : String) -> [[String:Any]] {
        
        var ret:[[String:Any]] = []
        for i in 0..<target.count {
            let obj = target[i]
            if let chk = obj[key] as? String
            {
                if chk == value
                {
                    ret.append(obj)
                }
            }
        }
        return ret
    }
    // [String:Any]
    class func objectforKeyValue(_ target : [[String:Any]], key : String, value : String) -> [String:Any] {
        
        var ret:[String:Any] = [:]
        for i in 0..<target.count {
            let obj = target[i]
            if let chk = obj[key] as? String
            {
                if chk == value
                {
                    ret = obj
                    break
                }
            }
        }
        return ret
    }
}
