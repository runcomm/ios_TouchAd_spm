//
//  BincodeResponse.swift
//  TouchadSDK
//
//  Created by shimtaewoo on 2020/11/20.
//

// import ObjectMapper

class BincodeResponse: BaseResponse {
    
    var data: [Bincode]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class Bincode: Mappable {
    
    var binIdx: Int?
    var binCd: String?
    var no: String?
    var company: String?
    var name: String?
    var kind: String?
    var pubDt: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        binIdx <- map["bin_idx"]
        binCd <- map["bin_cd"]
        no <- map["no"]
        company <- map["company"]
        name <- map["name"]
        kind <- map["kind"]
        pubDt <- map["save_path"]
    }
    
}
