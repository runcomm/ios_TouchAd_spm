//
//  NetworkManager.swift
//  touchad
//
//  Created by shimtaewoo on 2020/08/19.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import Alamofire
//import ObjectMapper

protocol NetworkManagerDelegate {
    func showAlert(_ msg: String)
    func showAlert(_ msg: String, _ handler: (() -> Void)?)
    func stopIndicator()
    func startIndicator()
}

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    // MARK: - Private
    
    // 공통 에러 코드 처리
    // ErrorCode에 case 추가하여 여기서 공통 처리 루틴 추가
    private func processError<T: BaseResponse>(_ delegate: NetworkManagerDelegate?, _ response: T) -> Bool {
        switch response.result {
//        case .ER010?:
//            if let msg = response.resultMessage {
//                delegate?.showAlert(msg)
//            }
//
//            return true
        default:
            return false
        }
    }
    
    // 통신 성공 시 에러코드에 따라 성공, 실패 판단. 실패 시 공통 에러 처리하여 실패 함수 호출
    private func success<T: BaseResponse>(_ delegate: NetworkManagerDelegate?, _ responseObject: T, successFunc: ((T) -> Void)? = nil, failureFunc: ((T?, Error?, Bool) -> Void)) {
        if let result = responseObject.result, result == 1 {
            successFunc?(responseObject)
        } else {
            let isProcessError = processError(delegate, responseObject)

            failureFunc(responseObject, nil, isProcessError)
        }
    }
    
    // 공통 헤더 정보 리턴
    private func getHeader() -> [String: String] {
        var header = ["Content-Type": "application/json", "Accept": "application/json"]
        
        /*if let accessToken = MCGlobalManager.sharedInstance.loginInfo?.accessToken {
            header["Authorization"] = "Bearer \(accessToken)"
        }*/
        
        return header
    }
    
    private func getHeader_HTTP() -> HTTPHeaders {
        var header : HTTPHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        
        /*if let accessToken = MCGlobalManager.sharedInstance.loginInfo?.accessToken {
            header["Authorization"] = "Bearer \(accessToken)"
        }*/
        
        return header
    }
    
    // 성공 분석 로그
    private func logEventSuccess(_ url: String, response: BaseResponse) {
        if let result = response.result, result == 1 {
            TAUtil.logEvent("api_request", category: url, action: "요청 성공")
        } else {
            TAUtil.logEvent("api_request", category: url, action: "요청 실패", label: "\(response.result ?? -1) \(response.error ?? "")")
        }
    }
    
    // 실패 분석 로그
    private func logEventError(_ error: Error, url: String) {
        TAUtil.logEvent("api_request", category: url, action: "요청 실패", label: String(describing: error))
    }
    
    // MARK: - Public
    
    func defaultFailFunc<T: BaseResponse>(_ delegate: NetworkManagerDelegate?, response: T?, error: Error?, isProcess: Bool, confirmHandler: (() -> Void)? = nil) {
        delegate?.stopIndicator()
        
        if let response = response {
            if !isProcess {
                if let error = response.error, let result = response.result, result != 1 {
                    delegate?.showAlert(error, confirmHandler)
                } else {
                    delegate?.showAlert(TAConstants.NETWORK_ERROR_MESSAGE, confirmHandler)
                }
            }
        } else {
            delegate?.showAlert(TAConstants.NETWORK_ERROR_MESSAGE, confirmHandler)
        }
    }
    
    // 일반적인 통신 함수
    func requestUrl<T: BaseResponse>(_ delegate: NetworkManagerDelegate?, _ url: String, headers: [String: String]? = nil, parameters: [String: Any]? = [String: Any](), method: HTTPMethod = .post, timeoutIntervalForRequest: TimeInterval = 60, isCommonProcess: Bool = true, successFunc: ((T) -> Void)? = nil, failureFunc: ((T?, Error?, Bool) -> Void)? = nil) {
        DispatchQueue.global().async {
            
            let fullUrl = url.hasPrefix("http") ? url : (TAUtil.getBaseServerUrl() + url)
            
            let failFunc = failureFunc ?? { (response, error, isProcess) in
                
                self.defaultFailFunc(delegate, response: response, error: error, isProcess: isProcess)
            }
            var urlRequest = URLRequest(url: URL(string: fullUrl)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutIntervalForRequest)

            printd("request url = \(fullUrl)")

            let originHeaders = self.getHeader()

            originHeaders.forEach { (key, value) in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }

            headers?.forEach { (key, value) in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }

            if let allHeaders = urlRequest.allHTTPHeaderFields {
                printd("headers = \(allHeaders)")
            }

            urlRequest.httpMethod = method.rawValue

            if let parameters = parameters {
                printd("parameters = \(parameters)")

                if let jsonData = parameters.toJson().data(using: .utf8) {
                    urlRequest.httpBody = jsonData
                }
            }

            Alamofire.request(urlRequest)
                .validate(statusCode: 200..<300)
                .responseJSON(completionHandler: { (response) in
                    printd("json response = \(response)")
                    
                    #if DEBUG
                    if let data = response.data
                    {
                        printd("json response decode utf8 = \(String(decoding: data, as: UTF8.self))")
                    }
                    #endif
                    
                    switch response.result {
                    case .success:
                        DispatchQueue.main.async {
                            
                        
                            if let value = Mapper<T>().map(JSONObject: response.value)
                            {
                                self.logEventSuccess(fullUrl, response: value)
                                
                                if isCommonProcess {
                                    self.success(delegate, value, successFunc: successFunc, failureFunc: failFunc)
                                } else {
                                    successFunc?(value)
                                }
                            }

                        }
                    case let .failure(error):
                        DispatchQueue.main.async {
                            // firebase analytics
                            self.logEventError(error, url: fullUrl)
                            failFunc(nil, error, false)
                        }
                    }
                    
                })
            

        }
    }
    
    func requestGetMethodUrl<T: BaseResponse>(_ delegate: NetworkManagerDelegate?, _ url: String, method: HTTPMethod = .get, timeoutIntervalForRequest: TimeInterval = 60, isCommonProcess: Bool = true, successFunc: ((T) -> Void)? = nil, failureFunc: ((T?, Error?, Bool) -> Void)? = nil) {
        DispatchQueue.global().async {
            
            let fullUrl = url.hasPrefix("http") ? url : (TAUtil.getBaseServerUrl() + url)
            
            let failFunc = failureFunc ?? { (response, error, isProcess) in
                
                self.defaultFailFunc(delegate, response: response, error: error, isProcess: isProcess)
            }
            var urlRequest = URLRequest(url: URL(string: fullUrl)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutIntervalForRequest)

            printd("request url = \(fullUrl)")

            let originHeaders = self.getHeader()

            originHeaders.forEach { (key, value) in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }

            if let allHeaders = urlRequest.allHTTPHeaderFields {
                printd("headers = \(allHeaders)")
            }

            urlRequest.httpMethod = method.rawValue

            Alamofire.request(urlRequest)
                .validate(statusCode: 200..<300)
                .responseJSON(completionHandler: { (response) in
                    printd("json response = \(response)")
                    
                    #if DEBUG
                    if let data = response.data
                    {
                        printd("json response decode utf8 = \(String(decoding: data, as: UTF8.self))")
                    }
                    #endif
                    
                    switch response.result {
                    case .success:
                        DispatchQueue.main.async {
                            
                        
                            if let value = Mapper<T>().map(JSONObject: response.value)
                            {
                                self.logEventSuccess(fullUrl, response: value)
                                
                                if isCommonProcess {
                                    self.success(delegate, value, successFunc: successFunc, failureFunc: failFunc)
                                } else {
                                    successFunc?(value)
                                }
                            }

                        }
                    case let .failure(error):
                        DispatchQueue.main.async {
                            // firebase analytics
                            self.logEventError(error, url: fullUrl)
                            failFunc(nil, error, false)
                        }
                    }
                    
                })
            

        }
    }
    
    // 이미지 업로드 통신 함수
    func requestUploadImage<T: BaseResponse>(_ delegate: NetworkManagerDelegate?, _ url: String, headers: [String: String]? = nil, image: UIImage, parameters: [String: Any]? = nil, successFunc: ((T) -> Void)? = nil, failureFunc: ((T?, Error?, Bool) -> Void)? = nil) {
        DispatchQueue.global().async {
            let fullUrl = TAUtil.getBaseServerUrl() + url
            let failFunc = failureFunc ?? { (response, error, isProcess) in
                delegate?.stopIndicator()
                
                if let response = response {
                    if !isProcess, let error = response.error, let result = response.result, result != 1 {
                        delegate?.showAlert(error)
                    }
                } else {
                    delegate?.showAlert(TAConstants.NETWORK_ERROR_MESSAGE)
                }
            }
            
            printd("request url = \(fullUrl)")
            printd("headers = \(self.getHeader())")
            
            if let parameters = parameters {
                printd("parameters = \(parameters)")
            }
            
            var requestHeaders : HTTPHeaders = [:]
            
            let originHeaders = self.getHeader()

            originHeaders.forEach { (key, value) in
                //requestHeaders.add(name: key, value: value) 20210216
                requestHeaders.updateValue(value, forKey: key)
            }
            
            headers?.forEach { (key, value) in
                //requestHeaders.add(name: key, value: value) 20210216
                requestHeaders.updateValue(value, forKey: key)
            }
            /*
            AF.upload(multipartFormData: { (multipartFormData) in
                
                if let imageData = image.jpegData(compressionQuality: 0.3) {
                    multipartFormData.append(imageData, withName: "Filedata", fileName: "file.png", mimeType: "application/octet-stream")
                }
                
            }, to: fullUrl, method: .post , headers: requestHeaders)
                .responseJSON { response in
                    
                    switch response.result {
                        
                    case .success:
                        
                        if let value = Mapper<T>().map(JSONObject: response.value)
                        {
                            DispatchQueue.main.async {
                                self.logEventSuccess(fullUrl, response: value)
                                self.success(delegate, value, successFunc: successFunc, failureFunc: failFunc)
                            }
                        }
                    case let .failure(error):
                        DispatchQueue.main.async {
                            // firebase analytics
                            self.logEventError(error, url: fullUrl)
                            failFunc(nil, error, false)
                        }
                    }
            }
            */
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if let imageData = image.jpegData(compressionQuality: 0.3) {
                    multipartFormData.append(imageData, withName: "Filedata", fileName: "file.png", mimeType: "application/octet-stream")
                }
                
            }, to: fullUrl, method: .post , headers: requestHeaders, encodingCompletion: { encodingResult in
                switch encodingResult {
                
                case .success(let upload, _, _):
                
                    upload.uploadProgress(closure: { (progress) in
                        print(progress.fractionCompleted)
                    })
                
                    upload.responseJSON(completionHandler:{response in
                        if let value = Mapper<T>().map(JSONObject: response.value)
                        {
                            DispatchQueue.main.async {
                                self.logEventSuccess(fullUrl, response: value)
                                self.success(delegate, value, successFunc: successFunc, failureFunc: failFunc)
                            }
                        }
                    })
                
                case .failure(let encodingError):
                
                    DispatchQueue.main.async {
                        // firebase analytics
                        self.logEventError(encodingError, url: fullUrl)
                        failFunc(nil, encodingError, false)
                    }
                
                }
            })
        }
    }
}
