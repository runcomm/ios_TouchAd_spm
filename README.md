#  TouchAd SDK  for Syrup 설치 가이드

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
* 아래 두개의 패키지를 추가하셔야 합니다.
* TouchadSDK SPM
```
https://github.com/runcomm/ios_TouchAd_spm.git

Dependency Rule : Exact Version 

Version : 0.0.7

Add to Project : Syrup앱프로젝트
```

* Alamofire SPM
```
https://github.com/Alamofire/Alamofire.git

Dependency Rule : Up to Next Minor Version 

Version : 5.9.0

Add to Project : Syrup앱프로젝트
```

2. **Package Dependencies 확인**
* 프로젝트 > Package Dependencies 메뉴 > Package 확인
```
TouchadSDK 0.0.7

Alamofire 5.9.0 < 최신버전
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
* 꽝없이 3번 랜덤 포인트 화면 시작
* @param isProd: 개발 / 상용 도메인을 설정하는 Bool 값 (필수, true = 상용 도메인, false = 개발 도메인)
* @param cid: 고객식별번호 (필수)
* @param gender: 성별(남자 : M, 여자 : F, 기타 : Z)
* @param birthYear: 출생년도(ex : 1996)
*/
func openEarningMenu(_ isProd : Bool, _ cid : String, _ gender : String?, _ birthYear : String?)

}
```


## 꽝없이 3번 랜덤 포인트 화면 시작

*  Syrup 앱 내 출석체크 화면에서 '꽝없이 3번 랜덤포인트' 버튼을 터치시 호출합니다.

*  아래는 꽝없이 3번 랜덤 포인트 화면 시작함수 예시입니다.
```
let isProd : Bool = true(상용 도메인) 또는 false(개발도메인)
let gender : String = "M"
let birthYear : String = "1996" 

TASDKManager.openEarningMenu(isProd, cid, gender, birthYear)
```

## Sample 프로젝트

* 프로젝트명 : ios_touchAd
* 위 설명한 모든 내용이 실제 코딩이 되어 있습니다.
* 실제 SDK 설치 시 참조하면 도움이 될 것입니다.

