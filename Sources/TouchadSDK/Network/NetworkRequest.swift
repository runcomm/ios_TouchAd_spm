//
//  NetworkRequest.swift
//  TouchadSDK
//
//  Created by shimtaewoo on 2020/08/31.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import Alamofire

class NetworkRequest: NSObject {
    
    // MARK: - 로그인
    class func requestLogin(_ delegate: NetworkManagerDelegate?, snsId: String? = nil, sns: String? = nil, id: String? = nil, pwd: String? = nil, pwdDecrytYn: String? = nil, success: ((UserResponse) -> Void)?, failure: ((UserResponse?, Error?, Bool) -> Void)? = nil) {
        //var parameters = ["pwd": pwd, "appOs": "IOS", "appVersion": MCUtil.getAppVersion(), "mobileManufacturer": "Apple", "mobileModel": MCUtil.getModel(), "adsId": MCUtil.getADID(), "appToken": MCGlobalManager.deviceToken]
        
        HTTPCookieStorage.shared.cookies?.forEach{
            (cookie) in
            if cookie.name == "mbrId"
            {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        //(
        //    HTTPCookieStorage.shared.deleteCookie
        //)
        
        var parameters = [String: String]()
        if let snsId = snsId, !snsId.isEmpty {
            parameters["snsId"] = snsId //sns_id
        }
        
        if let sns = sns, !sns.isEmpty {
            parameters["sns"] = sns
        }
        
        if let id = id, !id.isEmpty {
            parameters["id"] = id
        }
        
        if let pwd = pwd, !pwd.isEmpty {
            parameters["pwd"] = pwd
        }
        
        if let pwdDecrytYn = pwdDecrytYn, !pwdDecrytYn.isEmpty {
            parameters["pwdDecrytYn"] = pwdDecrytYn
        }
               
        
        NetworkManager.sharedInstance.requestUrl(delegate, TAConstants.URL_LOGIN, parameters: parameters, successFunc: { (response: UserResponse) in
            TAUtil.logEventLogin("로그인 성공")
            
            // adbrix
            //if let usrIdx = response.loginInfo?.usrIdx {
            //    AdBrixRM.getInstance.login(userId: String(usrIdx))
            //}
            
            success?(response)
        }) { (response: UserResponse?, error, isProcess) in
            TAUtil.logEventLogin("로그인 실패")
            failure?(response, error, isProcess)
        }
    }
    
    // MARK: - 회원정보
    class func requestUserInfo(_ delegate: NetworkManagerDelegate?, usrIdx: String? = nil, mbrId: String? = nil, success: ((UserResponse) -> Void)?, failure: ((UserResponse?, Error?, Bool) -> Void)? = nil) {
        //var parameters = ["pwd": pwd, "appOs": "IOS", "appVersion": MCUtil.getAppVersion(), "mobileManufacturer": "Apple", "mobileModel": MCUtil.getModel(), "adsId": MCUtil.getADID(), "appToken": MCGlobalManager.deviceToken]
        var parameters = [String: String]()
        if let usrIdx = usrIdx, !usrIdx.isEmpty {
            parameters["usrIdx"] = usrIdx
        }
        
        if let mbrId = mbrId, !mbrId.isEmpty {
            parameters["mbrId"] = mbrId
        }
        
        var headers = [String: String]()
        
        headers["Authorization"] = "Bearer \(TAGlobalManager.accessToken)"
        
        NetworkManager.sharedInstance.requestUrl(delegate, TAConstants.URL_USER_SELECT, headers: headers, parameters: parameters, successFunc: { (response: UserResponse) in
            TAUtil.logEventLogin("회원정보 성공")
            
            // adbrix
            //if let usrIdx = response.loginInfo?.usrIdx {
            //    AdBrixRM.getInstance.login(userId: String(usrIdx))
            //}
            
            success?(response)
        }) { (response: UserResponse?, error, isProcess) in
            TAUtil.logEventLogin("회원정보 실패")
            failure?(response, error, isProcess)
        }
    }
    
    // MARK: - 메인정보
    /*
     class func requestMainInfo(_ delegate: NetworkManagerDelegate?, usrIdx: Int, success: ((MainResponse) -> Void)?, failure: ((MainResponse?, Error?, Bool) -> Void)? = nil) {
         let parameters = ["usrIdx": usrIdx] as [String : Any]
         
         var headers = [String: String]()
         if let accessToken = TAGlobalManager.userInfo["access_token"] as? String
         {
             headers["Authorization"] = "Bearer \(accessToken)"
         }
         
         NetworkManager.sharedInstance.requestUrl(delegate, TAConstants.URL_MAIN_INFO, headers: headers, parameters: parameters, successFunc: success, failureFunc: failure)
     }
    
    // MARK: - 회원 프로필 이미지 업로드
    class func requestPictureUpload(_ delegate: NetworkManagerDelegate?, image: UIImage, success: ((FileResponse) -> Void)?, failure: ((FileResponse?, Error?, Bool) -> Void)?) {
        let parameters = [String: Any]()
        
        var headers = [String: String]()
        if let accessToken = TAGlobalManager.userInfo["access_token"] as? String
        {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        
        NetworkManager.sharedInstance.requestUploadImage(delegate, TAConstants.URL_FILE_UPLOAD, headers: headers, image: image, parameters: parameters, successFunc: success, failureFunc: failure)
    }
    */
    // MARK: - 회원 프로필 파일 업데이트
    class func requestUserUpdate(_ delegate: NetworkManagerDelegate?, parameters: [String: String], success: ((UserResponse) -> Void)?, failure: ((UserResponse?, Error?, Bool) -> Void)? = nil) {
        //var parameters = ["usr_idx": 132, "file_bundle": "IOS", "appVersion": MCUtil.getAppVersion(), "mobileManufacturer": "Apple", "mobileModel": MCUtil.getModel(), "adsId": MCUtil.getADID(), "appToken": MCGlobalManager.deviceToken]
        var headers = [String: String]()

        headers["Authorization"] = "Bearer \(TAGlobalManager.accessToken)"
        
        NetworkManager.sharedInstance.requestUrl(delegate, TAConstants.URL_USER_UPDATE, headers: headers, parameters: parameters, successFunc: { (response: UserResponse) in
            TAUtil.logEventLogin("회원업데이트 성공")
            
            // adbrix
            //if let usrIdx = response.loginInfo?.usrIdx {
            //    AdBrixRM.getInstance.login(userId: String(usrIdx))
            //}
            
            success?(response)
        }) { (response: UserResponse?, error, isProcess) in
            TAUtil.logEventLogin("회원업데이트 실패")
            failure?(response, error, isProcess)
        }
    }
    
    // MARK: - JWT 갱신
    class func requestJWTRefresh(_ delegate: NetworkManagerDelegate?, mbrId: String? = nil, platformId: String? = nil, success: ((UserResponse) -> Void)?, failure: ((UserResponse?, Error?, Bool) -> Void)? = nil) {
        
        var parameters = [String: String]()
        
        if let mbrId = mbrId, !mbrId.isEmpty {
           parameters["mbrId"] = mbrId
        }
        
        if let platformId = platformId, !platformId.isEmpty {
           parameters["platformId"] = platformId
        }
        
        var headers = [String: String]()

        headers["Authorization"] = "Bearer \(TAGlobalManager.accessToken)"
        
        NetworkManager.sharedInstance.requestUrl(delegate, TAConstants.URL_JWT_REFRESH, headers: headers, parameters: parameters, successFunc: { (response: UserResponse) in
            TAUtil.logEventLogin("토큰업데이트 성공")
            success?(response)
        }) { (response: UserResponse?, error, isProcess) in
            TAUtil.logEventLogin("토큰업데이트 실패")
            failure?(response, error, isProcess)
        }
    }

    // MARK: - JWT 발급
    class func requestJWTGenerate(_ delegate: NetworkManagerDelegate?, mbrId: String? = nil, platformId: String? = nil, success: ((UserResponse) -> Void)?, failure: ((UserResponse?, Error?, Bool) -> Void)? = nil) {
        
        var parameters = [String: String]()
        
        if let mbrId = mbrId, !mbrId.isEmpty {
           parameters["mbrId"] = mbrId
        }
        
        if let platformId = platformId, !platformId.isEmpty {
           parameters["platformId"] = platformId
        }
        
        let headers = [String: String]()
        
        NetworkManager.sharedInstance.requestUrl(delegate, TAConstants.URL_JWT_GENERATE, headers: headers, parameters: parameters, successFunc: { (response: UserResponse) in
            TAUtil.logEventLogin("토큰생성 성공")
            success?(response)
        }) { (response: UserResponse?, error, isProcess) in
            TAUtil.logEventLogin("토큰실패 실패")
            failure?(response, error, isProcess)
        }
    }
    
    // MARK: - VISION API 파일 업로드
    class func requestVisionUpload(_ delegate: NetworkManagerDelegate?, image: UIImage, success: ((TextResponse) -> Void)?, failure: ((TextResponse?, Error?, Bool) -> Void)?) {
        let parameters = [String: Any]()
        
        var headers = [String: String]()
        
        headers["Authorization"] = "Bearer \(TAGlobalManager.accessToken)"
        
        NetworkManager.sharedInstance.requestUploadImage(delegate, TAConstants.URL_FILE_VISION, headers: headers, image: image, parameters: parameters, successFunc: success, failureFunc: failure)
    }
    
    
    // MARK: - 지하철 실시간 도착정보 API
    class func requestArrivalRealtime(_ delegate: NetworkManagerDelegate?, name: String, success: (([[String:Any]]) -> Void)? = nil, failure: (([[String:Any]]?, Error?, Bool) -> Void)? = nil) {
        
        let url = "\(TAConstants.URL_ARRIVAL_REALTIME)/\(name)"
        
        Alamofire.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {(response) in
                printd("json response = \(response)")
                switch response.result {
                case .success(let obj):
                   if let json = obj as? NSDictionary
                   {
                        if let arrivals = json.object(forKey: "realtimeArrivalList") as? [[String:Any]]
                        {
                            success?(arrivals)
                        }
                        else
                        {
                            failure?([], nil, false)
                        }
                   }
                   else
                   {
                    NSLog("requestArrivalRealtime error : %@" , response.description)
                   }
                case .failure(let e):
                    failure?(nil, e, false)
                }
            })
    
    }

    // MARK: - 먼지 측정소 정보 API
    class func requestDustStation(_ delegate: NetworkManagerDelegate?, tmX: String, tmY: String, success: (([[String:Any]]) -> Void)? = nil, failure: (([[String:Any]]?, Error?, Bool) -> Void)? = nil) {
        
        let url = "\(TAConstants.URL_DUST_STATION)&tmX=\(tmX)&tmY=\(tmY)"
        
        Alamofire.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {(response) in
                printd("json response = \(response)")
                switch response.result {
                case .success(let obj):
                   if let json = obj as? NSDictionary
                   {
                        if let response = json.object(forKey: "response") as? NSDictionary
                        {
                            if let body = response.object(forKey: "body") as? NSDictionary
                            {
                                if let items = body.object(forKey: "items") as? [[String:Any]]
                                {
                                    success?(items)
                                }
                                else
                                {
                                    failure?([], nil, false)
                                }
                            }
                            else
                            {
                                failure?([], nil, false)
                            }
                        }
                        else
                        {
                            failure?([], nil, false)
                        }
                   }
                   else
                   {
                        failure?([], nil, false)
                   }
                case .failure(let e):
                    failure?(nil, e, false)
                }
            })
    
    }

    // MARK: - 먼지 측정 정보 API
    class func requestDustInfo(_ delegate: NetworkManagerDelegate?, stationName: String, success: (([[String:Any]]) -> Void)? = nil, failure: (([[String:Any]]?, Error?, Bool) -> Void)? = nil) {
        
        let url = "\(TAConstants.URL_DUST_INFO)&stationName=\(stationName.urlEncode())"
        
        Alamofire.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {(response) in
                printd("json response = \(response)")
                switch response.result {
                case .success(let obj):
                   if let json = obj as? NSDictionary
                   {
                        if let response = json.object(forKey: "response") as? NSDictionary
                        {
                            if let body = response.object(forKey: "body") as? NSDictionary
                            {
                                if let items = body.object(forKey: "items") as? [[String:Any]]
                                {
                                    success?(items)
                                }
                                else
                                {
                                    failure?([], nil, false)
                                }
                            }
                            else
                            {
                                failure?([], nil, false)
                            }
                        }
                        else
                        {
                            failure?([], nil, false)
                        }
                   }
                   else
                   {
                        failure?([], nil, false)
                   }
                case .failure(let e):
                    failure?(nil, e, false)
                }
            })
    
    }
    
    // MARK: - 날씨정보
    class func requestWeatherInfo(_ delegate: NetworkManagerDelegate?, baseDate: String, baseTime: String, nx: String, ny: String, success: (([[String:Any]]) -> Void)? = nil, failure: (([[String:Any]]?, Error?, Bool) -> Void)? = nil) {
        
        let url = "\(TAConstants.URL_WEATHER_INFO)&base_date=\(baseDate)&base_time=\(baseTime)&nx=\(nx)&ny=\(ny)"
        
        Alamofire.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: {(response) in
                printd("json response = \(response)")
                switch response.result {
                case .success(let obj):
                   if let json = obj as? NSDictionary
                   {
                        if let response = json.object(forKey: "response") as? NSDictionary
                        {
                            if let body = response.object(forKey: "body") as? NSDictionary
                            {
                                if let items = body.object(forKey: "items") as? NSDictionary
                                {
                                    if let item = items.object(forKey: "item") as? [[String:Any]]
                                    {
                                        success?(item)
                                    }
                                    else
                                    {
                                        failure?([], nil, false)
                                    }
                                }
                                else
                                {
                                    failure?([], nil, false)
                                }
                            }
                            else
                            {
                                failure?([], nil, false)
                            }
                        }
                        else
                        {
                            failure?([], nil, false)
                        }
                   }
                   else
                   {
                        failure?([], nil, false)
                   }
                case .failure(let e):
                    failure?(nil, e, false)
                }
            })
    
    }
}
