//
//  TextResponse.swift
//  TouchadSDK
//
//  Created by shimtaewoo on 2021/01/15.
//

// import ObjectMapper

class TextResponse: BaseResponse {
    
    var data: [Text]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class Text: Mappable {
    
    var cardNumber: String?
    var rectangles: [Rectangle]?
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        cardNumber <- map["card_number"]
        rectangles <- map["rectangles"]
    }
    
}

class Rectangle: Mappable {
    
    var text: String?
    var x: Int?
    var y: Int?
    var width: Int?
    var height: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        text <- map["text"]
        x <- map["x"]
        y <- map["y"]
        width <- map["width"]
        height <- map["height"]
    }
    
}
