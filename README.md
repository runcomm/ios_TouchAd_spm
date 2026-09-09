#  TouchAd SDK  for GETO 설치 가이드

* 정상적인 제휴서비스를 위한 터치애드SDK 설치과정을 설명합니다.
* 샘플 프로젝트를 참조하면 좀 더 쉽게 설치 가능합니다.

## CocoaPods 설정
1. **CocoaPods를 사용하지 않습니다.**


## Swift Package Manager 설정
1. **Package Dependencies 추가**
* 프로젝트 > 프로젝트아이콘 > Package Dependencies 탭 클릭
* PROJECT 프로젝트아이콘 클릭 
* Packages 메뉴 + 버튼 클릭
* 팝업화면 > Github 선택 > Search or Enter Package URL > 아래주소 입력
* 아래 네개의 패키지를 추가하셔야 합니다.
* TouchadSDK SPM
```
https://github.com/runcomm/ios_TouchAd_spm.git

Dependency Rule : Branch 

Branch Name
  1. 개발서버 : dev_geto
  2. 스테이지서버 : qa_geto
  3. 상용서버 : prod_geto

Add to Project : GETO앱 프로젝트
```

* Alamofire SPM
```
https://github.com/Alamofire/Alamofire.git

Dependency Rule : Exact Version 

Version : 5.12.0

Add to Project : GETO앱 프로젝트
```

* JWTDecode SPM
```
https://github.com/auth0/JWTDecode.swift

Dependency Rule : Exact Version 

Version : 4.0.0

Add to Project : GETO앱 프로젝트
```

* ObjectMapper SPM
```
https://github.com/tristanhimmelman/ObjectMapper.git

Dependency Rule : Exact Version 

Version : 4.4.3

Add to Project : GETO앱 프로젝트
```

2. **Package Dependencies 확인**
* 프로젝트 > Package Dependencies 메뉴 > Package 확인
```
TouchadSDK
  1. 개발서버 : dev_geto
  2. 스테이지서버 : qa_geto
  3. 상용서버 : prod_geto

Alamofire 5.12.0

JWTDecode 4.0.0

ObjectMapper 4.4.3
```

## 권한 설정
1. **광고식별자(IDFA)**
* 터치애드는 IDFA 값을 사용하여 사용자의 광고 사용 트래킹을 합니다.  
* IOS 14 이상부터 IDFA 를 사용하기 위해선 명시적으로 사용자 동의를 얻어야 합니다.
* 시뮬레이터로 동작 시 IDFA가 고정값으로 적용됩니다.(시뮬레이터에서 IDFA를 가져올 경우 값이 0으로 표현되어 화면진입이 되지 않는 문제 대응)
* 시뮬레이터용 IDFA 고정값 : aabc1234-a12b-a123-abcd-abcde1234567
* 앱프로젝트 info.plist 에 아래내용을 추가합니다.

| Key | Type | Value |
|---|---|---|
| Information Property List|Dictionary|(1 item)|
| Privacy - Tracking Usage Description|String|앱이 타겟광고게재 목적으로 IDFA에 접근하려고 합니다.|

* 앱프로젝트에서 IDFA 조회를 명시적으로 요청할 경우 아래와 같은 메서드를 작성하여 사용합니다.

```
func requestPermission() { 
    ATTrackingManager.requestTrackingAuthorization { status in 
        switch status { 
        case .authorized: 
            print("Authorized") 
        case .denied: 
            print("Restricted") 
        @unknown default: 
            print("Unknown") 
        } 
    } 
}
```

## 개인정보 보호 매니페스트 파일(Privacy manifest file)
1. **PrivacyInfo.xcprivacy**
* 2024년 5월 1일부터 특정 API를 사용할 경우 허용된 사유가 포함된 PrivacyInfo.xcprivacy 파일이 프로젝트에 포함되어야 합니다.
* 터치애드 SDK 산출물내 포함된 PrivacyInfo.xcprivacy에 아래내용을 추가했습니다.
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyTrackingDomains</key>
    <array/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeDeviceID</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <false/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeThirdPartyAdvertising</string>
            </array>
        </dict>
    </array>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

## 터치애드 플랫폼 클래스 함수

- 주요기능을 모듈화하여 Static 함수형태로 호출합니다.
- 아래 간략한 설명입니다.
```
public class TASDKManager: NSObject {

/**
* 하루 세번 포인트 화면 시작
* @param cid: geto 사용자 식별 번호 (필수)
*/
func openEarningMenu(_ cid : String)

/**
* 쓰고받는 포인트 화면 시작
* @param cid: geto 사용자 식별 번호 (필수)
*/
func openApprlNoMenu(_ cid : String)

/**
* 쓰고받는 포인트 전면광고 오픈
* @param cid: geto 사용자 식별 번호 (필수)
* @param userInfoString: 승인데이터 (필수)
*/
func openAdvertise(_ mbrId : String, userInfoString: String)

}
```



## 쓰고받는 포인트 전면광고 화면 시작 (백그라운드, IOS >= 10)

*  GETO 결제 푸시 수신하고 이때 쓰고받는 포인트 전면광고 화면을 띄울 경우 호출합니다.

*  GETO 앱이 미실행 상태이거나 백그라운드 상태일 경우 MP앱이 실행된후에 전면광고 화면이 나타납니다.

*  아래는 돈 버는 교통 전면광고 시작함수 호출 예시입니다.
```
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    TASDKManager.openAdvertise("geto 사용자 식별 번호", userInfoString: notification.request.content.userInfo)
        
    completionHandler()
}
```

## 쓰고받는 포인트 전면광고 화면 시작 (포그라운드, IOS >= 10)

*  GETO 결제 푸시 수신하고 이때 쓰고받는 포인트 전면광고 화면을 띄울 경우 호출합니다.

*  GETO 앱이 실행 상태일 경우 전면광고 화면이 나타납니다.

*  아래는 쓰고받는 포인트 전면광고 시작함수 호출 예시입니다.
```
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    printd("willPresentNotification = \(notification.request.content.userInfo)")
    
        TASDKManager.openAdvertise("geto 사용자 식별 번호", userInfoString: notification.request.content.userInfo)
    
    completionHandler([.alert, .badge, .sound])
}
```


## 하루 세번 포인트 화면 시작

*  GETO 앱 내에서 하루 세번 포인트 메뉴를 선택하면 약관동의 거치고 하루 세번 포인트 화면을 시작할때 호출합니다.

*  아래는 하루 세번 포인트 화면 시작함수 호출 예시입니다.
```
TASDKManager.openEarningMenu("geto 사용자 식별 번호")
```

## 쓰고받는 포인트 화면 시작

*  GETO 앱 내에서 쓰고받는 포인트 메뉴를 선택하면 약관동의 거치고 쓰고받는 포인트 화면을 시작할때 호출합니다.

*  아래는 쓰고받는 포인트 화면 시작함수 호출 예시입니다.
```
TASDKManager.openApprlNoMenu("geto 사용자 식별 번호")
```

## FCM 전송

* 터치애드는 푸시 송신 시 MP 에서 제공한 Public API를 이용하여 Push(FCM)를 전송합니다.
* Form파라미터(**필수**)

| 파라미터 | 내용 |
|---|---|
| `touchad`|문자열|

* API를 통해 Post된 데이터를 FCM데이터 구성요소 중 data와 payload 프로퍼티에 담아서 FCM전송 바랍니다.(※ 변경 가능성 있습니다.)

* FCM 전송 포맷 예시
```
{
  "android": {
    "priority": "high",
    "data": {\"title\":\"Notification Title\",\"body\":\"Notification Contents\",\"cid\":\"\(cid)\",\"apprlNo\":\"12345678\",\"apprlAmount\":\"1200\",\"partnerCode\":\"2104\",\"postCd\":\"58848\",\"domain\":\"s.ta.runcomm.co.kr\"}"
  },
  "apns": {
    "headers": {
      "apns-priority": "10"
    },
    "payload": {\"title\":\"Notification Title\",\"body\":\"Notification Contents\",\"cid\":\"\(cid)\",\"apprlNo\":\"12345678\",\"apprlAmount\":\"1200\",\"partnerCode\":\"2104\",\"postCd\":\"58848\",\"domain\":\"s.ta.runcomm.co.kr\"}",
    "fcm_options": {
      "image": "https://s.ta.runcomm.co.kr/html/img/profile00.png"
    }
  },
  "tokens": [
    "f3T_OObOQX-yo4J3y5bjcG:APA91bGzI2k8Fiz41ivql0ZV10hXLJz7w11Ne5Nf9IiZ1FymlJcGi-QRzv2lg3k46AYKamx-va2dyzj7m6TJTfCSTzTuPA7chomgSO_7PIh4LjsJ33SP7pDUoPvlGOeiM6oi5YXLiGvL"
  ]
}
```

## 빌드시  주의사항

* 애플 앱스토어 혹은 TestFlight 를 통한 앱배포시에는 x86_64 아키텍쳐 빌드가 제외된 SDK 로 빌드하여야 합니다.
* arm64  빌드 SDK :  폴더/ios_touchAd_sdk/TouchadSDK.xcframework

## Sample 프로젝트

* 프로젝트명 : ios_touchAd
* 위 설명한 모든 내용이 실제 코딩이 되어 있습니다.
* 실제 SDK 설치 시 참조하면 도움이 될 것입니다.

