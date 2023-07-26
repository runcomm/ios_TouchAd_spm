//
//  AppPushResultResponse.swift
//  TouchadSDK
//
//  Created by 이윤표 on 2023/05/15.
//

// import ObjectMapper

class AppPushResultResponse: BaseResponse {
    
    var data: [AppPush]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}
