//
//  BaseResponse.swift
//  touchad
//
//  Created by shimtaewoo on 2020/08/19.
//  Copyright © 2020 developer. All rights reserved.
//

// import ObjectMapper

class BaseResponse: Mappable {
    var result: Int?
    var error: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        error <- map["error"]
    }
}
