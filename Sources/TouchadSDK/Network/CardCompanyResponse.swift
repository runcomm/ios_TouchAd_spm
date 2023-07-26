//
//  CardCompanyResponse.swift
//  TouchadSDK
//
//  Created by shimtaewoo on 2020/09/04.
//

// import ObjectMapper

class CardCompanyResponse: BaseResponse {
    
    var data: [CardCompany]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class CardCompany: Mappable {
    
    var company: String?
    var no: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        company <- map["company"]
        no <- map["no"]
    }
    
}
