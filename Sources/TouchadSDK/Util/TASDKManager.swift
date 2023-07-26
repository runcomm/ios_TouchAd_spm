//
//  TASDKManager.swift
//  TouchadSDK
//
//  Created by shimtaewoo on 2020/11/17.
//

import UIKit
import Foundation

@objc public class TASDKManager: NSObject {
    
    //static private var mMbrId: String = ""
    //static private var mPlatformId: String = ""
    static private var bcCallback: (() -> Void)? = nil
    
    public static var mbrId: String {
        get {
            return TAGlobalManager.mbrId
        }
    }
    
    public static func initializeA(_ mbrId : String, platformId : String) {
        
        TAGlobalManager.mbrId = mbrId
        TAGlobalManager.platformId = platformId
                
    }

    public static func initializeA(_ mbrId : String, platformId : String, pushToken : String?) {
        
        TAGlobalManager.deviceToken = pushToken ?? ""
        TAGlobalManager.mbrId = mbrId
        TAGlobalManager.platformId = platformId
                
    }
    
    /*
    @available(iOS 10.0, *)
    public static func openAdvertise(_ notification: UNNotification){
        
        let userInfo = notification.request.content.userInfo
        
        if let deepLink = userInfo["touchad"] as? String
        {
            if let vc = TAUtil.getNavigationController()?.visibleViewController {
                //let link = "touchad://ta.runcomm.co.kr/html/advertise_img_select_mobile.html" //photo
                if vc.presentingViewController == nil {
                    TAGlobalManager.goDeepLink(vc, deepLink: deepLink)
                    return
                }
            }
        }
        
    }
    */
    
//    @objc public static func openAdvertiseA(_ userInfo: [AnyHashable : Any]){
//
//        if let deepLink = userInfo["touchad"] as? String
//        {
//            if let vc = TAUtil.getNavigationController()?.visibleViewController {
//                //let link = "touchad://ta.runcomm.co.kr/html/advertise_img_select_mobile.html" //photo
//                if vc.presentingViewController == nil {
//                    TAGlobalManager.goDeepLink(vc, deepLink: deepLink)
//                    return
//                }
//            }
//        }
//
//    }
    
//    @objc public static func startTouchAdWebviewA(){
//
//        if let vc = TAUtil.getNavigationController()?.visibleViewController {
//
//            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
//            let wvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
//            wvc.titleName = "TOUCH AD"
//            wvc.url = TAConstants.WEBURL_ADVERTISE_LIST
//            vc.navigationController?.pushViewController(wvc, animated: true)
//
//        }
//
//    }

    @objc public static func openBCPlusMoneyMenu(_ isProd : Bool,_ mbrId : String) {
        
        TAGlobalManager.isProd = isProd
        TAGlobalManager.mbrId = mbrId
        TAGlobalManager.platformId = TAConstants.PLATFORM_ID_TODAY_EARNING
        
        if let vc = TAUtil.getNavigationController()?.visibleViewController {
        
            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
            let wvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
            wvc.titleName = "TOUCH AD"
            wvc.url = TAConstants.WEBURL_TODAY_MONEY_VIEW
            vc.navigationController?.pushViewController(wvc, animated: true)
        
        }
                
    }
    
    @objc public static func openBCPlusBannerMenu(_ isProd : Bool,_ mbrId : String) {
        
        TAGlobalManager.isProd = isProd
        TAGlobalManager.mbrId = mbrId
        TAGlobalManager.platformId = TAConstants.PLATFORM_ID_TODAY_EARNING
        
        if let vc = TAUtil.getNavigationController()?.visibleViewController {
            
            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
            let wvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
            wvc.titleName = "TOUCH AD"
            wvc.url = TAConstants.WEBURL_TODAY_BANNER_VIEW
            vc.navigationController?.pushViewController(wvc, animated: true)
        
        }
                
    }
    
    @objc public static func openBCPlusMainMenu(_ isProd : Bool, _ mbrId : String) {
        
        TAGlobalManager.isProd = isProd
        TAGlobalManager.mbrId = mbrId
        TAGlobalManager.platformId = TAConstants.PLATFORM_ID_TODAY_EARNING
        
        if let vc = TAUtil.getNavigationController()?.visibleViewController {
            
            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
            let wvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
            wvc.titleName = "TOUCH AD"
            wvc.url = TAConstants.WEBURL_TODAY_MAIN_VIEW
            vc.navigationController?.pushViewController(wvc, animated: true)
        
        }
                
    }
    
//    @objc public static func openBCEarningMenu(_ mbrId : String) {
//
//        TAGlobalManager.mbrId = mbrId
//        TAGlobalManager.platformId = TAConstants.PLATFORM_ID_EARNING
//
//        if let vc = TAUtil.getNavigationController()?.visibleViewController {
//
//            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
//            let wvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
//            wvc.titleName = "TOUCH AD"
//            wvc.url = TAConstants.WEBURL_ADVERTISE_LIST
//            vc.navigationController?.pushViewController(wvc, animated: true)
//
//        }
//
//    }
    
//    @objc public static func openMPTouchadMenu(_ mbrId : String, adPushYn : String, gender : String, birthYear : String, callback: (() -> Void)?) {
//
//        mpCallback = callback
//        TAGlobalManager.mbrId = mbrId
//        TAGlobalManager.platformId = TAConstants.PLATFORM_ID_TOUCHAD
//        TAGlobalManager.adPushYn = adPushYn
//        TAGlobalManager.gender = gender
//        TAGlobalManager.birthYear = birthYear
//
//        if let vc = TAUtil.getNavigationController()?.visibleViewController {
//
//            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
//            let wvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
//            wvc.titleName = "TOUCH AD"
//            wvc.url = TAConstants.WEBURL_TOUCHAD_MAIN
//            vc.navigationController?.pushViewController(wvc, animated: true)
//
//        }
//
//    }
//
//    @objc public static func openMPAdvertise(_ mbrId : String, userInfo: [AnyHashable : Any]){
//
//        NSLog("openMPAdvertise userInfo : " + userInfo.description)
//
//                TAGlobalManager.mbrId = mbrId
//                TAGlobalManager.platformId = TAConstants.PLATFORM_ID_TOUCHAD
//                if let customType = userInfo["custom-type"] as? String {
//
//                    if customType == "touchad" {
//
//                        if let deepLink = userInfo["custom-body"] as? String
//                        {
//                            NSLog("openMPAdvertise String : " + deepLink)
//                            if let dic = deepLink.urlDecode().toDictionary()
//                            {
//                                NSLog("openMPAdvertise String Dic : " + dic.description)
//                                if let deepLink = dic["touchad"] as? String
//                                {
//                                    NSLog("openMPAdvertise String Dic touchad : " + deepLink)
//                                    if let vc = TAUtil.getNavigationController()?.visibleViewController {
//                                        //let link = "touchad://ta.runcomm.co.kr/html/advertise_img_select_mobile.html" //photo
//                                        NSLog("openMPAdvertise String Dic touchad nav")
//                                        if vc.presentingViewController == nil {
//                                            NSLog("openMPAdvertise String Dic touchad nav not present")
//                                            TAGlobalManager.goDeepLink(vc, deepLink: deepLink)
//                                            return
//                                        }
//                                    }else{
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000)) {
//                                            NSLog("openMPAdvertise 2sec String Dic touchad : " + deepLink)
//                                            if let vc = TAUtil.getNavigationController()?.visibleViewController {
//                                                //let link = "touchad://ta.runcomm.co.kr/html/advertise_img_select_mobile.html" //photo
//                                                NSLog("openMPAdvertise 2sec String Dic touchad nav")
//                                                if vc.presentingViewController == nil {
//                                                    NSLog("openMPAdvertise 2sec String Dic touchad nav not present")
//                                                    TAGlobalManager.goDeepLink(vc, deepLink: deepLink)
//                                                    return
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                else
//                {
//                    NSLog("custom-type is not defined")
//                }
//    }
//
//    @objc public static func openMPEarningResult(_ mbrId : String, userInfo: [AnyHashable : Any]) {
//
//        NSLog("openMPEarningResult userInfo : " + userInfo.description)
//
//        TAGlobalManager.mbrId = mbrId
//        TAGlobalManager.platformId = TAConstants.PLATFORM_ID_EARNING
//        TAGlobalManager.bannerYn = TAConstants.NO
//
//        if let customType = userInfo["custom-type"] as? String {
//
//            if customType == "touchad" {
//
//                if let deepLink = userInfo["custom-body"] as? String
//                {
//                    NSLog("openMPEarningResult String : " + deepLink)
//                    if let dic = deepLink.urlDecode().toDictionary()
//                    {
//                        NSLog("openMPEarningResult String Dic : " + dic.description)
//                        if let dalcoin = dic["dalcoin"] as? String
//                        {
//                            NSLog("openMPEarningResult String Dic dalcoin : " + dalcoin)
//
//                            if let platformId = dic["platformId"] as? String
//                            {
//                                NSLog("openMPEarningResult String Dic platformId : " + platformId)
//                                if platformId == TAConstants.PLATFORM_ID_EARNING
//                                {
//
//                                    if let vc = TAUtil.getNavigationController()?.visibleViewController
//                                    {
//                                        dalCoinNavigation(vc, dalcoin)
//                                    }
//                                    else
//                                    {
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000)) {
//                                            NSLog("openMPEarningResult 3sec String Dic touchad : " + dalcoin)
//                                            if let vc = TAUtil.getNavigationController()?.visibleViewController
//                                            {
//                                                NSLog("openMPEarningResult 3sec String Dic touchad nav")
//                                                dalCoinNavigation(vc, dalcoin)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        else
//        {
//            NSLog("custom-type is not defined")
//        }
//    }
    
    @objc public static func openBCSettingMenu() {
        
        if bcCallback != nil
        {
            bcCallback?()
        }
        
    }
    
//    @objc private static func dalCoinNavigation(_ vc : UIViewController, _ coinString : String)
//    {
//        if vc.simpleClassName.contains("CommonWebViewController")
//        {
//            NSLog("openMPEarningResult String Dic touchad nav touchad or earning")
//            let cvc = vc as! CommonWebViewController
//            let urlString = cvc.url ?? ""
//            if urlString.contains(TAConstants.WEBURL_ADVERTISE_LIST)
//            {
//                NSLog("openMPEarningResult String Dic touchad nav WEBURL_ADVERTISE_LIST")
//                dalCoinMessage(cvc, coinString)
//            }
//            else if urlString.contains(TAConstants.WEBURL_INQUIRY_INSERT)
//            {
//                NSLog("openMPEarningResult String Dic touchad nav WEBURL_INQUIRY_INSERT")
//                cvc.backAction({})
//                dalCoinMessage(cvc, coinString)
//            }
//            else if urlString.contains(TAConstants.WEBURL_ADVERTISE_SELECT_CHARGING)
//            {
//                NSLog("openMPEarningResult String Dic touchad nav WEBURL_ADVERTISE_SELECT_CHARGING")
//                cvc.backAction({})
//                if let vc = TAUtil.getNavigationController()?.visibleViewController
//                {
//                    dalCoinMessage(vc, coinString)
//                }
//            }
//            else
//            {
//                NSLog("openMPEarningResult String Dic touchad nav may be TOUCHAD")
//                let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
//                let wvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
//                wvc.titleName = "TOUCH AD"
//                wvc.url = TAConstants.WEBURL_ADVERTISE_LIST
//                vc.navigationController?.pushViewController(wvc, animated: true)
//                dalCoinMessage(wvc, coinString)
//            }
//        }
//        else
//        {
//            NSLog("openMPEarningResult String Dic touchad nav mp")
//            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
//            let wvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
//            wvc.titleName = "TOUCH AD"
//            wvc.url = TAConstants.WEBURL_ADVERTISE_LIST
//            vc.navigationController?.pushViewController(wvc, animated: true)
//            dalCoinMessage(wvc, coinString)
//        }
//    }
//
//    @objc private static func dalCoinMessage(_ vc : UIViewController, _ coinString : String)
//    {
//        //let msg = "참여적립에서 우주코인 \r\n" + coinString + "C가 적립되었습니다."
//
//        let coinNumber = Int(coinString) ?? 0
//        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.rgb(229,170,255)]
//
//        let firstString = NSMutableAttributedString(string: "참여적립에서 T 플러스포인트 \r\n")
//        let secondString = NSAttributedString(string: coinNumber.withComma + "P", attributes: secondAttributes)
//        let thirdString = NSAttributedString(string: " 적립되었어요!")
//
//        firstString.append(secondString)
//        firstString.append(thirdString)
//
//        //CommonPopupView.createView(vc.view, title: TAConstants.DALCOIN_MESSAGE_TITLE, attributeText: firstString, confirmText: TAConstants.DALCOIN_MESSAGE_OK_TITLE, confirmAction: nil)
//        DalCoinPopupView.createView(vc.view, attributeText: firstString, textAlign: .center)
//
//    }
//
//    @objc public static func openMPBanner(_ mbrId : String, adPushYn : String, gender : String, birthYear : String) {
//
//        TAGlobalManager.mbrId = mbrId
//        TAGlobalManager.platformId = TAConstants.PLATFORM_ID_EARNING
//        TAGlobalManager.adPushYn = adPushYn
//        TAGlobalManager.gender = gender
//        TAGlobalManager.birthYear = birthYear
//        TAGlobalManager.bannerYn = TAConstants.YES
//
//        if let vc = TAUtil.getNavigationController()?.visibleViewController {
//
//            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
//            let wvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
//            wvc.titleName = "TOUCH AD"
//            wvc.url = TAConstants.WEBURL_ADVERTISE_LIST
//            vc.navigationController?.pushViewController(wvc, animated: true)
//
//        }
//
//    }
//
//    @objc public static func openMPApprlNoMenu(_ mbrId : String, adPushYn : String, gender : String, birthYear : String) {
//        TAGlobalManager.mbrId = mbrId
//        TAGlobalManager.platformId = TAConstants.PLATFORM_ID_APPRL_NO
//        TAGlobalManager.adPushYn = adPushYn
//        TAGlobalManager.gender = gender
//        TAGlobalManager.birthYear = birthYear
//
//        if let vc = TAUtil.getNavigationController()?.visibleViewController {
//            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
//            let wvc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
//            wvc.titleName = "TOUCH AD"
//            wvc.url = TAConstants.WEBURL_APPRL_NO_LIST
//            vc.navigationController?.pushViewController(wvc, animated: true)
//        }
//    }
}
