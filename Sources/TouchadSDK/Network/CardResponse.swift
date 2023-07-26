//
//  CardResponse.swift
//  TouchadSDK
//
//  Created by shimtaewoo on 2020/09/04.
//  Copyright © 2020 developer. All rights reserved.
//

// import ObjectMapper

class CardResponse: BaseResponse {
    
    var data: [Card]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}
