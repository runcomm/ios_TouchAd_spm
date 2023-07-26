//
//  UserResponse.swift
//  TouchadSDK
//
//  Created by shimtaewoo on 2020/08/31.
//  Copyright © 2020 developer. All rights reserved.
//

// import ObjectMapper

class UserResponse: BaseResponse {
    
    var data: [User]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

class User: Mappable {
    
    var id: String?
    var pwd: String?
    var usrIdx: Int?
    var email: String?
    var areaIdx: Int?
    var birthYear: Int?
    var gender: String?
    var point: Int?
    var notiYn: String?
    var byeYn: String?
    var byeDatetime: String?
    var signupDatetime: String?
    var uuid: String?
    var comm: String?
    var os: String?
    var sns: String?
    var snsId: String?
    var nick: String?
    var fileBundle: String?
    var hand: String?
    var loginPath: String?
    var loginDatetime: String?
    var mbrId: String?
    var adsId: String?
    var platformUsrIdx: Int?
    var cards: [Card]?
    var notiToken: String?
    var accessToken: String?
    var agreeYn: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        pwd <- map["pwd"]
        usrIdx <- map["usr_idx"]
        email <- map["email"]
        areaIdx <- map["area_idx"]
        birthYear <- map["birth_year"]
        gender <- map["gender"]
        point <- map["point"]
        notiYn <- map["noti_yn"]
        byeYn <- map["bye_yn"]
        byeDatetime <- map["bye_datetime"]
        signupDatetime <- map["signup_datetime"]
        uuid <- map["uuid"]
        comm <- map["comm"]
        os <- map["os"]
        sns <- map["sns"]
        snsId <- map["sns_id"]
        nick <- map["nick"]
        fileBundle <- map["file_bundle"]
        hand <- map["hand"]
        loginPath <- map["login_path"]
        loginDatetime <- map["login_datetime"]
        mbrId <- map["mbr_id"]
        adsId <- map["ads_id"]
        platformUsrIdx <- map["platform_idx"]
        cards <- map["cards"]
        notiToken <- map["noti_token"]
        accessToken <- map["access_token"]
        agreeYn <- map["agree_yn"]
    }
    
}

class Card: Mappable {
    
    var cardIdx: Int?
    var useYn: String?
    var regDatetime: String?
    var usrIdx: Int?
    var cardCompany: String?
    var cardNo: String?
    var savePath: String?
    var hash: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cardIdx <- map["card_idx"]
        useYn <- map["use_yn"]
        regDatetime <- map["reg_datetime"]
        usrIdx <- map["usr_idx"]
        cardCompany <- map["card_company"]
        cardNo <- map["card_no"]
        savePath <- map["save_path"]
        hash <- map["hash"]
    }
    
}

class AppPush: Mappable {
    var notiYn: String?
    var adsNotiYn: String?
    var mbrId: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        notiYn <- map["notiYn"]
        adsNotiYn <- map["adsNotiYn"]
        mbrId <- map["mbrId"]
    }
}
