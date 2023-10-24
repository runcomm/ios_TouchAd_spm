//
//  TAConstants.swift
//  touchad
//
//  Created by shimtaewoo on 2020/09/01.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class TAConstants: NSObject {
    
    static let SDK_BUNDLE_IDENTIFIER = "TouchadSDK"
    
    static let SDK_VERSION = "1.4"
    
    // 개발 서버 접속 여부
//    static let IS_DEV = true
//    static let IS_DEV = false
    // 디버그 프린트 출력 여부
//    static let DEBUG_PRINT = true
//    static let DEBUG_PRINT = false
    static let GUIDE_PAGE_COUNT = 4
    
    static let PLATFORM_ID_EARNING = "BCV"
    static let PLATFORM_ID_TODAY_EARNING = "BCW"
    static let OS = "I"
    static let ACCESS_TOKEN_EXPIRE_ERROR = -1065
    static let ACCESS_TOKEN_REFRESH_TITLE = "사용자인증이 만료되었습니다. 갱신하겠습니까?"
    static let ACCESS_TOKEN_REFRESH_ERROR = "사용자인증이 실패했습니다."
    
    //Yes or No select
    static let YES = "Y"
    static let NO = "N"
    
    // base url
    static let DEV_SERVER_BASE_URL = "https://t.ta.runcomm.co.kr"
    static let REAL_SERVER_BASE_URL = "https://3.ta.runcomm.co.kr"
    
    // gcp cloud url
    static let DEV_GCP_IMG_URL = "https://storage.googleapis.com/touchad-upload"
    static let REAL_GCP_IMG_URL = "https://storage.googleapis.com/touchad-upload"
   
    static let DEEPLINK_PREFIX = "touchad"
    static let DEEPLINK_JS_PREFIX = "touchadjs"
    
    static let IMG_PROFILE_NAME = "profile00.png"
    static let IMG_MIDDLE_BANNER_NAME = "banner00.png"
    static let IMG_BOTTOM_BANNER_NAME = "banner01.png"
    
    //cauly
    static let MESSAGE_HANDLER_NAME = "scriptHandler"
    static let VIDEO_CLOSE_FUNCTION_NAME = "videoClose"
    static let VIDEO_END_FUNCTION_NAME = "videoEnd"
    static let VIDEO_EXTERNAL_HOST_PREFIX = "https://ad.pointclick.co.kr"
    
    // 에러 메세지
    static let NETWORK_ERROR_MESSAGE = "네트워크 상태를 확인해주세요."
    static let SERVER_ERROR_MESSAGE = "서버 에러 발생. 잠시 후 다시 시도해 주세요."
    
    // 일반
    static let COMMON_POPUP_TITLE = "알림"
    static let COMMON_CONFIRM_TITLE = "확인"
    static let COMMON_POPUP_MESSAGE = ""
    static let COMMON_CANCEL_TITLE = "취소"
    static let COMMON_CONTINUE_TITLE = "계속보기"
    static let COMMON_EXIT_TITLE = "나가기"
    static let COMMON_SETTING_TITLE = "설정"
    static let COMMON_KEYBOARD_COMPLETE_TITLE = "완료"
    
    //광고
    static let ADVERTISE_VIDEO_EXIT_MESSAGE = "광고를 끝까지 시청하셔야 포인트가 적립됩니다."
    
    //일대일문의
    static let INQUIRY_SUCCESS_MESSAGE = "정상적으로 등록되었습니다."
    
    //광고아이디
    static let IDFA_EARNING_MENU = "플러스적립"
    static let IDFA_ALERT_MESSAGE_BOLD = "을 위해 아래의 '설정'을 선택하여 '추적 허용' 옵션을 활성화 한 후, 다시 시도해주세요."
    static let IDFA_ALERT_MESSAGE_REGULAR_1 = "\n\n※ 설정 > 페이북/ISP에서 ‘추적허용’ 항목을 탭하면 팝업이 노출되며, 해당 팝업에서 ‘허용’을 선택하시면 됩니다."
    static let IDFA_ALERT_MESSAGE_REGULAR_2 = "\n\n※ 설정 > 개인정보 보호 및 보안 > 추적 선택 후 페이북/IPS 우측 버튼을 활성화로 변경하시면 됩니다."
    
    // Universal Link Domain
    static let UNIVERSAL_LINK_DOMAIN = "ta.runcomm.co.kr"
    
    // web url
    static let WEBURL_GUIDE = "/srv/user/mobile/guide"
    static let WEBURL_LOGIN = "/srv/user/mobile/login"
    static let WEBURL_SETTING = "/srv/user/mobile/update"
    static let WEBURL_SING_UP_ADDITIONAL = "/srv/user/mobile/options"  //회원정보 추가
    static let WEBURL_SING_UP_COMPLETE = "/srv/user/mobile/complete"  //회원가입 완료
    static let WEBURL_USER_MYPAGE = "/srv/user/mobile/mypage"  //mypage
    static let WEBURL_USER_MYPAGE_TOUCHAD = "/srv/user/mobile/mypage/bc"  //mypage touchad
    static let WEBURL_USER_AGREE = "/srv/user/mobile/agree"  //약관동의
    static let WEBURL_USER_INSERT = "/srv/user/mobile/insert"  //회원가입
    static let WEBURL_USER_AGREE_PRIVATE = "/srv/board/mobile/select/p/bc" //개인 정보 취급 방침
    static let WEBURL_USER_POINT_LIST = "/srv/advertise_point_transaction/mobile/list" //포인트 적립 리스트
    static let WEBURL_USER_DISCOUNT_LIST = "/srv/comm_discount_transaction/mobile/list/discount"  //할인 리스트
    static let WEBURL_USER_DISCOUNT_INSERT = "/srv/comm_discount_transaction/mobile/insert" //할인 금액 신청
    static let WEBURL_INQUIRY_INSERT = "/srv/inquiry/mobile/insert/bc" //1:1 문의 등록
    static let WEBURL_ADVERTISE_LIST = "/srv/advertise/mobile/list/bc" //충전소목록
    static let WEBURL_TODAY_MONEY_VIEW = "/srv/advertise/mobile/list/money/bc" //머니박스 당첨화면에서 플러스 적립 진입
    static let WEBURL_TODAY_BANNER_VIEW = "/srv/advertise/mobile/list/banner/bc" //출석체크 클로징배너에서 플러스 적립 진입
    static let WEBURL_TODAY_MAIN_VIEW = "/srv/advertise/mobile/list/main/bc" //출석체크 메인 화면에서 플러스 적립 진입
    static let WEBURL_ADVERTISE_SELECT = "/srv/advertise/mobile/select/bc" //모바일웹광고
    static let WEBURL_ADVERTISE_MOVIE_TEST = "/srv/advertise/mobile/movie/bc" //모바일동영상광고테스트
    static let WEBURL_BINCODE_SELECT = "/srv/bin_code/api/select" //BINCODE조회
    static let WEBURL_ADVERTISE_SELECT_CHARGING = "/srv/advertise/mobile/select/charging/bc" //광고상세
    static let WEBURL_TOUCHAD_MAIN = "/srv/index/mobile/main/bc" //터치애드메인
    static let WEBURL_CARD_LIST = "/srv/card/mobile/list/bc" //교통카드관리
    static let WEBURL_USER_CONFIGURE = "/srv/user/mobile/update/bc" //광고푸시설정
    static let WEBURL_BOARD_NOTICE_LIST = "/srv/board/mobile/list/n/bc" //공지사항리스트
    static let WEBURL_BOARD_INFO = "/srv/board/mobile/info/bc" //이용방법
    static let WEBURL_USAGE_GUIDE = "/srv/board/mobile/select/u/bc" //개인 정보 취급 방침
    static let WEBURL_BOARD_NOTICE_SELECT = "/srv/board/mobile/select/bc" //공지사항상세
    static let WEBURL_APPRL_NO_LIST = "/srv/card/mobile/list/approval/bc" //참여이력 화면
    static let WEBURL_BOARD_FAQ_LIST = "/srv/board/mobile/list/f/bc" //FAQ 메인 화면
    static let WEBURL_BOARD_FAQ_SELECT = "/srv/board/mobile/select/faq/bc" //FAQ 상세화면
    static let WEBURL_TOUCHAD_MAIN_SETTING = "/srv/user/mobile/update/bc" //돈 버는 교통 설정 화면
    
    
    // urls
    static let URL_LOGIN = "/srv/user/api/login"
    static let URL_FILE_UPLOAD = "/srv/file/api/save"
    static let URL_MAIN_INFO = "/srv/main/api"
    static let URL_USER_SELECT = "/srv/user/api/select"
    static let URL_USER_UPDATE = "/srv/user/api/update"
    static let URL_CARD_COMPANY_LIST = "/srv/card/api/list/company"
    static let URL_CARD_INSERT = "/srv/card/api/insert"
    static let URL_JWT_REFRESH = "/srv/jwt/api/refresh"
    static let URL_JWT_GENERATE = "/srv/jwt/api/generate"
    static let URL_FILE_VISION = "/srv/file/api/vision"
    static let URL_ARRIVAL_REALTIME = "http://swopenapi.seoul.go.kr/api/subway/766a6c6d786e7a6f31323346536e6243/json/realtimeStationArrival/0/20"
    static let URL_APP_PUSH_CHECK = "/srv/user/api/select/push"
    static let URL_APP_PUSH_UPDATE = "/srv/user/api/update/push"
    static let URL_DUST_STATION = "http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getNearbyMsrstnList?serviceKey=IeQii9akYDZCXfkaw9TCP2w9y4reQ7iwr9BA%2F4xWiZATLgLboNZKxe5JNx8B7HLXPTp7Fekp%2BQcZtMkqBtVM0Q%3D%3D&pageNo=1&numOfRows=1&returnType=json"
    static let URL_DUST_INFO = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?dataTerm=DAILY&pageNo=1&numOfRows=1&ServiceKey=IeQii9akYDZCXfkaw9TCP2w9y4reQ7iwr9BA%2F4xWiZATLgLboNZKxe5JNx8B7HLXPTp7Fekp%2BQcZtMkqBtVM0Q%3D%3D&returnType=json&ver=1.0"
    static let URL_WEATHER_INFO = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getUltraSrtFcst?ServiceKey=IeQii9akYDZCXfkaw9TCP2w9y4reQ7iwr9BA%2F4xWiZATLgLboNZKxe5JNx8B7HLXPTp7Fekp%2BQcZtMkqBtVM0Q%3D%3D&pageNo=1&numOfRows=100&dataType=json"
    static let URL_MOVIE_STOP = "https://t.ta.runcomm.co.kr/srv/advertise/mobile/stop"
}
