//
//  TAUtil.swift
//  touchad
//
//  Created by shimtaewoo on 2020/09/03.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
//import KeychainItemWrapper
//import CryptoSwift
import AdSupport
//import Firebase
//import NMapsMap
import WebKit

// 전역 디버그 로그 함수
public func printd(_ item: Any, function: String = #function, file: String = #file, line: Int = #line) {
    if (TAGlobalManager.isProd == false) {
        let filenames = file.split(separator: "/")
        
        print("[\(Date().format("yyyy-MM-dd HH:mm:ss.SSS"))][\(filenames.last!)][\(line)] \(item)")
    }
}

extension URL {
    func appending(_ key: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        if value == nil || value!.isEmpty
        {
            return self
        }
        else
        {
            var cs = CharacterSet.urlQueryAllowed
            cs.remove("+")
            // Create array of existing query items
            var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
            
            for _ in 0 ..< queryItems.count {
                let item = queryItems[0]
                //itemValue를 디코딩
                let decodeItemValue = item.value?.urlDecode()
                let queryItem = URLQueryItem(name: item.name, value: decodeItemValue?.addingPercentEncoding(withAllowedCharacters: cs))
                queryItems.remove(at: 0)
                queryItems.append(queryItem)
                printd("queryItems : \(String(describing: queryItems[0].value))")
            }
            // Create query item
            let queryItem = URLQueryItem(name: key, value: value)
            // Append the new query item in the existing query items array
            queryItems.append(queryItem)
            // Append updated query items array in the url component object
            urlComponents.queryItems = queryItems
            // Returns the url from new url components
            return urlComponents.url!
        }
    }
    
    func appendingNonExistence(_ key: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        printd("urlComponents description : \(urlComponents.description)")
        
        if value == nil || value!.isEmpty
        {
            return self
        }
        else
        {
            // Create array of existing query items
            var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
            for queryItem in queryItems {
                if (queryItem.name == key)
                {
                    return self
                }
            }
            
            var cs = CharacterSet.urlQueryAllowed
            cs.remove("+")
            
            for _ in 0 ..< queryItems.count {
                let item = queryItems[0]
                //itemValue를 디코딩
                let decodeItemValue = item.value?.urlDecode()
                let queryItem = URLQueryItem(name: item.name, value: decodeItemValue?.addingPercentEncoding(withAllowedCharacters: cs))
                queryItems.remove(at: 0)
                queryItems.append(queryItem)
                
                printd("queryItems : \(String(describing: queryItems[0].value))")
            }
            // Create query item
            let queryItem = URLQueryItem(name: key, value: value)
            // Append the new query item in the existing query items array
            queryItems.append(queryItem)
            // Append updated query items array in the url component object
            urlComponents.queryItems = queryItems
            // Returns the url from new url components
            return urlComponents.url!
        }
    }
    
    func updateExistence(_ key: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        printd("urlComponents description : \(urlComponents.description)")
        
        if value == nil || value!.isEmpty
        {
            return self
        }
        else
        {
            var cs = CharacterSet.urlQueryAllowed
            cs.remove("+")
            // Create array of existing query items
            var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
            
            for _ in 0 ..< queryItems.count {
                let item = queryItems[0]
                //itemValue를 디코딩
                let decodeItemValue = item.value?.urlDecode()
                let queryItem = URLQueryItem(name: item.name, value: decodeItemValue?.addingPercentEncoding(withAllowedCharacters: cs))
                queryItems.remove(at: 0)
                if (item.name != key)
                {
                    queryItems.append(queryItem)
                }
                
                printd("queryItems : \(String(describing: queryItems[0].value))")
            }
            // Create query item
            let queryItem = URLQueryItem(name: key, value: value)
            // Append the new query item in the existing query items array
            queryItems.append(queryItem)
            // Append updated query items array in the url component object
            urlComponents.queryItems = queryItems
            // Returns the url from new url components
            return urlComponents.url!
        }
    }
    
    func isQueryItemNameAndValue(checkName: String, checkValue: String) -> Bool {
        guard let urlComponents = URLComponents(string: absoluteString) else { return false }
        let queryItems = urlComponents.queryItems ?? []
        
        for queryItem in queryItems
        {
            if (queryItem.name == checkName && queryItem.value == checkValue)
            {
                return true
            }
        }
        return false
    }
}

extension Date {
    // 날짜를 포맷에 맞는 형식의 스트링으로 리턴
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
    
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = format
    
        return formatter.string(from: self)
    }
}
extension WKWebView {
    func goBackToFirstItemInHistory() {
        let script = "window.history.go(-(window.history.length - 1));"
        evaluateJavaScript(script) { (_, error) in
            
        }
    }
}
extension String {
    var lastString: String {
            get {
                if self.isEmpty { return self }

                let lastindex = self.index(before: self.endIndex)
                return String(self[lastindex])
            }
        }
    
    // 스트링을 포맷에 맞는 형식의 날짜로 리턴
    func format(_ format: String) -> Date? {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = format
        
        return formatter.date(from: self)
    }
    
    // url 인코딩
    func urlEncode() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    // url 디코딩
    func urlDecode() -> String {
        return removingPercentEncoding ?? ""
    }
    
    // 공통 request 반환
    func getRequest() -> URLRequest {
        let request = URLRequest.init(url: URL.init(string: getFullUrl())!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60)
        
        printd("request url = \(request)")
        
        return request
    }
    
    // 전체 url 리턴. http로 시작 시 그대로 리턴. 그렇지 않을 경우 base url 붙여서 리턴.
    func getFullUrl() -> String {
        if hasPrefix("http") {
            return self
        } else {
            return TAUtil.getBaseServerUrl() + self
        }
    }
    
    // url을 dictionary 형태로 변환
    func parseScheme() -> [String: String] {
        var dic = [String: String]()
        let index = firstIndex(of: ":") ?? endIndex
        
        dic["scheme"] = String(self[..<index])
        
        guard let tempIndex = self.index(index, offsetBy: 3, limitedBy: endIndex) else {
            return dic
        }
        
        let str = String(self[tempIndex...])
        
        if !str.isEmpty {
            let strIndex = str.firstIndex(of: "?") ?? str.endIndex
            
            dic["command"] = String(str[..<strIndex])
            
            guard let str1Index = str.index(strIndex, offsetBy: 1, limitedBy: str.endIndex) else {
                return dic
            }
            
            let str1 = String(str[str1Index...])
            
            if !str1.isEmpty {
                let params = str1.components(separatedBy: "&")
                
                params.forEach { param in
                    let paramSplit = param.components(separatedBy: "=")
                    
                    if paramSplit.count == 2 {
                        dic[paramSplit[0]] = paramSplit[1]
                    }
                }
            }
        }
        
        return dic
    }
    
//    // aes256 암호화
//    func encryptAES256(_ key: String) -> String {
//        let ret = try? encryptToBase64(cipher: AES(key: MCConstants.PASSWORD_KEY, iv: ""))
//
//        return (ret ?? "")!
//    }
//
//    // aes256 복호화
//    func decryptAES256(_ key: String) -> String {
//        var ret = ""
//
//        do {
//            ret = try decryptBase64ToString(cipher: AES(key: MCConstants.PASSWORD_KEY, iv: ""))
//        } catch {
//            printd("decryptAES256 fail")
//        }
//
//        return ret
//    }
    
    // 전화번호 유효성 체크
    func isValidPhoneNumber() -> Bool {
        let regex = "01([0|1|6|7|8|9])([0-9]{3,4})([0-9]{4})$"
        let phone = replacingOccurrences(of: "-", with: "")
        
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phone)
    }
    
    // 이메일 유효성 체크
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        
        if valid {
            valid = !contains("Invalid email id")
        }
        
        return valid
    }
    
    // 영어, 한글, 숫자 입력 체크
    func isValidString() -> Bool {
        
        // 영어, 한글, 숫자, 천지인 특수문자(·) 허용
        let filter = "[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ·]"
        let regex = try! NSRegularExpression(pattern: filter, options: [])
        let list = regex.matches(in: self, options: [], range: NSRange.init(location: 0, length:count))
        
        return list.count == count
    }
    
    // 영어, 한글 입력 체크
    func isValidOnlyString() -> Bool {
        let filter = "[a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ]"
        let regex = try! NSRegularExpression(pattern: filter, options: [])
        let list = regex.matches(in: self, options: [], range: NSRange.init(location: 0, length:count))
        
        return list.count == count
    }
    
    // 영어, 숫자 입력 체크
    func isValidEngNum() -> Bool {
        let filter = "[a-zA-Z0-9\\s]"
        let regex = try! NSRegularExpression(pattern: filter, options: [])
        let list = regex.matches(in: self, options: [], range: NSRange.init(location: 0, length:count))
        
        return list.count == count
    }
    
    // 영어, 숫자 입력 체크
    func isValidCreditCard() -> Bool {
        let filter = "[0-9]"
        let regex = try! NSRegularExpression(pattern: filter, options: [])
        let list = regex.matches(in: self, options: [], range: NSRange.init(location: 0, length:count))
        
        return list.count == count && count == 16
    }
    
    // 영어, 숫자 둘 다 하나 이상 포함 체크
    func isValidPassword() -> Bool {
        let filter = "^(?=.*\\d)(?=.*[a-zA-Z]).*"
        
        return NSPredicate(format: "SELF MATCHES %@", filter).evaluate(with: self)
    }
    
    // substring 대체 함수들
    subscript(_ r: CountableRange<Int>) -> String {
        get {
            let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }

    // substring 대체 함수들
    subscript(_ range: CountableClosedRange<Int>) -> String {
        get {
            return self[range.lowerBound..<range.upperBound + 1]
        }
    }
    
    // substring 대체 함수들
    subscript(safe range: CountableRange<Int>) -> String {
        get {
            if count == 0 { return "" }
            let lower = range.lowerBound < 0 ? 0 : range.lowerBound
            let upper = range.upperBound < 0 ? 0 : range.upperBound
            let s = index(startIndex, offsetBy: lower, limitedBy: endIndex) ?? endIndex
            let e = index(startIndex, offsetBy: upper, limitedBy: endIndex) ?? endIndex
            return String(self[s..<e])
        }
    }
    
    // substring 대체 함수들
    subscript(safe range: CountableClosedRange<Int>) -> String {
        get {
            if count == 0 { return "" }
            let closedEndIndex = index(endIndex, offsetBy: -1, limitedBy: startIndex) ?? startIndex
            let lower = range.lowerBound < 0 ? 0 : range.lowerBound
            let upper = range.upperBound < 0 ? 0 : range.upperBound
            let s = index(startIndex, offsetBy: lower, limitedBy: closedEndIndex) ?? closedEndIndex
            let e = index(startIndex, offsetBy: upper, limitedBy: closedEndIndex) ?? closedEndIndex
            return String(self[s...e])
        }
    }
    
    // substring 대체 함수들
    func substring(_ startIndex: Int, length: Int) -> String {
        let start = index(self.startIndex, offsetBy: startIndex)
        let end = index(self.startIndex, offsetBy: startIndex + length)
        return String(self[start..<end])
    }
    
    // substring 대체 함수들
    subscript(i: Int) -> Character {
        get {
            let index = self.index(startIndex, offsetBy: i)
            return self[index]
        }
    }
    
    // 전화번호 유효성 검사 및 - 추가
    func toPhoneFormat() -> String? {
        if isValidPhoneNumber() {
            if count == 10 {
                return "\(substring(0, length: 3))-\(substring(3, length: 3))-\(substring(6, length: 4))"
            } else {
                return "\(substring(0, length: 3))-\(substring(3, length: 4))-\(substring(7, length: 4))"
            }
        }
        
        return nil
    }
    
    // 전화번호 입력 중 - 추가
    func toPhoneFormatting() -> String? {
        if count <= 11 {
            if count == 11 {
                return "\(substring(0, length: 3))-\(substring(3, length: 4))-\(substring(7, length: count - 7))"
            } else if count >= 7 {
                return "\(substring(0, length: 3))-\(substring(3, length: 3))-\(substring(6, length: count - 6))"
            } else if count >= 4 {
                return "\(substring(0, length: 3))-\(substring(3, length: count - 3))"
            } else {
                return self
            }
        }
        
        return nil
    }
    
    // 좌우 빈캐릭터 삭제
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // 앱에 맞는 기본 날짜 스트링으로 변환
    func changeBasicDateFormat() -> String {
        return format("yyyy-MM-dd HH:mm:ss")?.format("yyyy.MM.dd E HH:mm") ?? ""
    }
    
    // 특정 스트링에 컬러 추가
    func addKeywordColor(keywords: [(String, UIColor)]) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: self)
        
        keywords.forEach { (keyword, color) in
            let range = (self as NSString).range(of: keyword)
            
            attrStr.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        return attrStr
    }
    
    // 특정 스트링에 컬러 추가
    func addKeywordColor(keywords: [String], color: UIColor) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: self)
        
        keywords.forEach { keyword in
            let range = (self as NSString).range(of: keyword)
            
            attrStr.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        return attrStr
    }
    
    // 특정 스트링에 볼드 추가
    func addKeywordBold(keywords: [String], size: CGFloat) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: self)
        
        keywords.forEach { keyword in
            let range = (self as NSString).range(of: keyword)
            
            attrStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: size), range: range)
        }
        
        return attrStr
    }
    
    // 특정 스트링에 언더라인 추가
    func addKeywordUnderline(keywords: [String], color: UIColor? = nil) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: self)
        
        keywords.forEach { keyword in
            let range = (self as NSString).range(of: keyword)
            
            attrStr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            
            if let color = color {
                attrStr.addAttribute(.underlineColor, value: color, range: range)
            }
        }
        
        return attrStr
    }
    
    // 특정 스트링에 취소라인 추가
    func addKeywordStrikethrough(keywords: [String]) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: self)
        
        keywords.forEach { keyword in
            let range = (self as NSString).range(of: keyword)
            
            attrStr.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        
        return attrStr
    }
    
    // 특정 스트링 폰트사이즈 수정
    func changeKeywordFontSize(keywords: [String] , fontSize: CGFloat) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: self)
        
        keywords.forEach { keyword in
            let range = (self as NSString).range(of: keyword)
            attrStr.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: range)
        }
        
        return attrStr
    }
    
    // 마지막에 특정 문자가 존재하면 삭제하여 리턴
    func removeLastString(_ str: String?) -> String {
        if let str = str, hasSuffix(str) {
            return substring(0, length: count - str.count).trim()
        }
        
        return self
    }
    
    // 특정 스트링에 컬러, 볼드 추가
    func addKeyword_Color_Bold(keywords_color: [String], color: UIColor, keywords_bold: [String], size: CGFloat) -> NSMutableAttributedString {
        let attrStr = NSMutableAttributedString.init(string: self)
        
        keywords_color.forEach { keyword in
            let range = (self as NSString).range(of: keyword)
            
            attrStr.addAttribute(.foregroundColor, value: color, range: range)
        }
        keywords_bold.forEach { keyword in
            let range = (self as NSString).range(of: keyword)
            
            attrStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: size), range: range)
        }
        
        return attrStr
    }
    
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
    
    // 행정구역 명칭 수정
    func replaceAddressType() -> String
    {
        switch self {
        case "충남":
            return "충청남도"
        case "충북":
            return "충청북도"
        case "전남":
            return "전라남도"
        case "전북":
            return "전라북도"
        case "경남":
            return "경상남도"
        case "경북":
            return "경상북도"
        default :
            return self
        }
    }
    
    
    func htmlAttributed() -> NSMutableAttributedString {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(17)\">%@</span>", self)
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        let attrStr = try! NSMutableAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        attrStr.addAttributes([ NSAttributedString.Key.paragraphStyle: style ], range: NSRange(location: 0, length: attrStr.length))
        
        return attrStr
    }
    
    func toDictionary() -> [String: Any]?
    {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
extension UILabel {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize+3)\">%@</span>", htmlText)
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        let attrStr = try! NSMutableAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        attrStr.addAttributes([ NSAttributedString.Key.paragraphStyle: style ], range: NSRange(location: 0, length: attrStr.length))
        
        self.attributedText = attrStr
    }
}

extension NSMutableAttributedString {
    // 특정 스트링에 컬러 추가
    func addKeywordColor(keywords: [String], color: UIColor) -> NSMutableAttributedString {
        keywords.forEach { keyword in
            let range = (self.string as NSString).range(of: keyword)
            
            addAttribute(.foregroundColor, value: color, range: range)
        }
        
        return self
    }
    
    // 특정 스트링에 볼드 추가
    func addKeywordBold(keywords: [String], size: CGFloat) -> NSMutableAttributedString {
        keywords.forEach { keyword in
            let range = (self.string as NSString).range(of: keyword)
            
            addAttribute(.font, value: UIFont.boldSystemFont(ofSize: size), range: range)
        }
        
        return self
    }
    
    // 특정 스트링에 언더라인 추가
    func addKeywordUnderline(keywords: [String], color: UIColor? = nil) -> NSMutableAttributedString {
        keywords.forEach { keyword in
            let range = (self.string as NSString).range(of: keyword)
            
            addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            
            if let color = color {
                addAttribute(.underlineColor, value: color, range: range)
            }
        }
        
        return self
    }
}

extension UIColor {
    
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }

    
    // color to uiimage
    func imageWithColor() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        self.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // rgb to uicolor
    class func rgb(_ r: Int, _ g: Int, _ b: Int, _ a: Float = 1.0) -> UIColor {
        return UIColor.init(red: CGFloat(r) / CGFloat(255), green: CGFloat(g) / CGFloat(255), blue: CGFloat(b) / CGFloat(255), alpha: CGFloat(a))
    }
    
    // rgb to uicolor
    class func rgb(_ hex: UInt32) -> UIColor {
        if hex > 0xffffff {
            return UIColor.init(red: CGFloat((hex & 0xff0000) >> 16) / CGFloat(255), green: CGFloat((hex & 0xff00) >> 8) / CGFloat(255), blue: CGFloat(hex & 0xff) / CGFloat(255), alpha: CGFloat((hex & 0xff000000) >> 24) / CGFloat(255))
        } else {
            return UIColor.init(red: CGFloat((hex & 0xff0000) >> 16) / CGFloat(255), green: CGFloat((hex & 0xff00) >> 8) / CGFloat(255), blue: CGFloat(hex & 0xff) / CGFloat(255), alpha: 1)
        }
    }
    enum AssetsColor {
        case ableCouponColor
        case unableCouponColor
        case selectCouponColor
        case startMarkerColor
        case arriveMarkerColor
    }
    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .ableCouponColor:
            return #colorLiteral(red: 0.1490196078, green: 0.3882352941, blue: 0.3607843137, alpha: 1)
        case .unableCouponColor:
            return #colorLiteral(red: 0.6745098039, green: 0.6745098039, blue: 0.6745098039, alpha: 1)
        case .selectCouponColor:
            return #colorLiteral(red: 0.8705882353, green: 0.1529411765, blue: 0.3960784314, alpha: 1)
        case .startMarkerColor:
            return #colorLiteral(red: 0.1490196078, green: 0.3882352941, blue: 0.3607843137, alpha: 1)
        case .arriveMarkerColor:
            return #colorLiteral(red: 0.8941176471, green: 0.3843137255, blue: 0.5568627451, alpha: 1)
        }
        
    }
    
}
@objc class ClosureSleeve: NSObject {
    let closure: ()->()

    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}


extension Dictionary {
    // json으로 변환
    func toJson() -> String {
        var jsonStr: String = ""
        
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            jsonStr = String.init(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            printd("Dictionary to String convert fail");
        }
        
        return jsonStr.replacingOccurrences(of: "\n", with: "");
    }
}

extension Array {
    // json으로 변환
    func toJson() -> String {
        var jsonStr: String = ""
        
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            jsonStr = String.init(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            printd("Array to String convert fail");
        }
        
        return jsonStr;
    }
}

extension Int {
    // Int to Data
    var data: Data {
        var int = self
        
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
    
    // 숫자에 ,표시
    var withComma: String {
        let decimalFormatter = NumberFormatter()
        
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.groupingSize = 3
        
        return decimalFormatter.string(from: self as NSNumber)!
    }

    // int to '시간 분' 표시
    var toTime: String {
        if self >= 3600 * 24 {
            let isEmptyHour = self % (3600 * 24) / 3600 == 0
            let isEmptyMinute = self % 3600 / 60 == 0
            
            return "\(self / (3600 * 24))일\(isEmptyHour ? "" : " \(self % (3600 * 24) / 3600)시간")\(isEmptyMinute ? "" : " \(self % 3600 / 60)분")"
        } else if self >= 3600 {
            let isEmptyMinute = self % 3600 / 60 == 0
            
            return "\(self / 3600)시간\(isEmptyMinute ? "" : " \(self % 3600 / 60)분")"
        } else if self >= 0 {
            return "\(self / 60)분"
        } else {
            return "0분"
        }
    }
}

extension UIDatePicker {
    //시간 '분' 값, 10분 단위로 절삭
    //예약출발시간 설정, MaxDate 상황
    public var clampedDate: Date {
        let referenceTimeInterval = self.date.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(minuteInterval*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
    }
}

extension String {
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
}

extension Date {
    //두 시간 사이에 속하는 확인
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}

extension UINavigationController {
    // 현 viewcontroller를 replace
    func replaceViewController(_ viewController: UIViewController, animated: Bool = true) {
        if viewControllers.count > 0 {
            var vcs = viewControllers
            
            vcs.removeLast()
            vcs.append(viewController)
            setViewControllers(vcs, animated: animated)
        } else {
            pushViewController(viewController, animated: animated)
        }
    }
    
    // step 수만큼 이전 화면으로 이동
    func popViewController(_ step: Int, animated: Bool = true) {
        if viewControllers.count > step + 1 {
            var vcs = viewControllers
            
            vcs.removeLast(step)
            setViewControllers(vcs, animated: animated)
        } else {
            popToRootViewController(animated: animated)
        }
    }
    
    // 이전 viewcontroller를 get
    func getPrevViewController() -> UIViewController? {
        if viewControllers.count > 1 {
            return viewControllers[viewControllers.count - 2]
        }
        
        return nil
    }
    // 뷰 컨트롤러 교체 not remove just reverse
    func replaceViewController()
    {
        var vcs = viewControllers
        
        if vcs.count < 2 {return}
        
        let controller = vcs[vcs.count - 2]
        vcs.append(controller)
        vcs.remove(at: vcs.count - 3)
        
        viewControllers = vcs
    }
    // 특정 뷰컨트롤러 제거
    /*func removSpecificVC( VC : KindOfViewController )
    {
        var vcs = viewControllers
        
        if vcs.count < 2 {return}
        
        for (index, element) in vcs.enumerated() {
            switch VC {
            case .NewSelectMapVC:
                if element is NewSelectMapViewController {
                    vcs.remove(at: index)
                    
                    viewControllers = vcs
                    
                    break
                }
            case .LocationSearchVC:
                if element is LocationSearchViewController {
                    vcs.remove(at: index)
                    
                    viewControllers = vcs
                    break
                }
            }
        }
        
    }
    
    enum KindOfViewController {
        case NewSelectMapVC
        case LocationSearchVC
    }*/
}
extension UIScrollView {

    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }

}

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical

    var startPoint : CGPoint {
        return points.startPoint
    }

    var endPoint : CGPoint {
        return points.endPoint
    }

    var points : GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
        case .horizontal:
            return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
        case .vertical:
            return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
        }
    }
}

extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGPoint {
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }

     }

    @IBInspectable var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue / 2.0
        }
    }
    
    // 실선 컬러, 두께, 패턴 추가
    func addDashedBorder(color: UIColor, lineWidth: CGFloat = 1, lineDashPattern: [NSNumber] = [5, 5]) {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = lineDashPattern
        
        let path = CGMutablePath()
        
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func toImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            // Fallback on earlier versions
            return UIImage()
        }
    }

    func applyGradient(with colours: [UIColor], locations: [NSNumber]? = nil, cornerRadius: CGFloat? = 0) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = cornerRadius ?? 0
        self.layer.insertSublayer(gradient, at: 0)
    }

    func applyGradient(with colours: [UIColor], gradient orientation: GradientOrientation, cornerRadius: CGFloat? = 0) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        gradient.cornerRadius = cornerRadius ?? 0
        //gradient.masksToBounds = true
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension NSObject {
    // 클래스명 리턴
    var simpleClassName: String {
        let names = NSStringFromClass(type(of: self)).components(separatedBy: ".")
        
        return names.last ?? "NoNameClass"
    }
}
/*
extension TMapView {
    // 마커 추가 및 교체
    func addMarker(_ markerId: String, image: UIImage?, lon: Double, lat: Double, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        if let point = TMapPoint(lon: lon, lat: lat) {
            if let marker = getMarketItem(fromID: markerId) {
                marker.setTMapPoint(point)
                marker.setIcon(image, anchorPoint: anchorPoint)
            } else if let marker = TMapMarkerItem(tMapPoint: point) {
                marker.setIcon(image, anchorPoint: anchorPoint)
                marker.enableClustering = true
                addTMapMarkerItemID(markerId, marker: marker, animated: true)
            } else {
                printd("fail to create marker")
            }
        } else {
            printd("fail to create point")
        }
    }
    
    func addMarker(_ markerId: String, image: String, lon: Double, lat: Double, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        addMarker(markerId, image: UIImage(named: image), lon: lon, lat: lat, anchorPoint: anchorPoint)
    }
    
    // 마커 추가 및 교체
    func addMarker(_ markerId: String, image: String, coordinate: CLLocationCoordinate2D, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        addMarker(markerId, image: image, lon: coordinate.longitude, lat: coordinate.latitude, anchorPoint: anchorPoint)
    }
    
    // 맵 이동
    func setCenter(lon: Double, lat: Double, animated: Bool = true) {
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        setCenter(location, animated: animated)
    }
    
    // 두 거리의 최적화된 zoomLevel로 zoom
    func zoomFit(orgLon: Double, orgLat: Double, dstLon: Double, dstLat: Double, animated: Bool = true) {
        if let point1 = TMapPoint(lon: orgLon, lat: orgLat), let point2 = TMapPoint(lon: dstLon, lat: dstLat), let info = getDisplayTMapInfo([point1, point2]) {
            zoomLevel = info.zoomLevel
            setCenter(info.mapPoint.coordinate, animated: animated)
        }
    }
    
    // 두 거리의 최적화된 zoomLevel로 zoom - 1
    func zoomFitDownZoomLevel(orgLon: Double, orgLat: Double, dstLon: Double, dstLat: Double, animated: Bool = true) {
        if let point1 = TMapPoint(lon: orgLon, lat: orgLat), let point2 = TMapPoint(lon: dstLon, lat: dstLat), let info = getDisplayTMapInfo([point1, point2]) {
            zoomLevel = info.zoomLevel - 1
            setCenter(info.mapPoint.coordinate, animated: animated)
        }
    }
    
    // 한 좌표 zoom
    func zoomFit(lon: Double, lat: Double, animated: Bool = true) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        zoom(toLatSpan: 0.01, lonSpan: 0.01)
        setCenter(center, animated: animated)
    }

    // 예상 경로 표시
    func addTMapPath(_ features: [Feature], color: UIColor, lineWidth: CGFloat) {
        let polyLines = TMapPolyLine()
        
        for feature in features {
            if let type = feature.geometry?.type, let coordinates = feature.geometry?.coordinates, type == "LineString" {
                for coordinate in coordinates {
                    polyLines.addPoint(TMapPoint(lon: coordinate[0], lat: coordinate[1]))
                }
            }
        }
        
        polyLines.setLineColor(color.cgColor)
        polyLines.setLineWidth(Float(lineWidth))
        addTMapPath(polyLines)
    }

    // 예상 경로 표시
    func addTMapPath(_ positions: [Position]?, color: UIColor, lineWidth: CGFloat) {
        let polyLines = TMapPolyLine()
        
        if let positions = positions {
            for position in positions {
                if let lon = position.lon, let lat = position.lat {
                    polyLines.addPoint(TMapPoint(lon: lon, lat: lat))
                }
            }
        }
        
        polyLines.setLineColor(color.cgColor)
        polyLines.setLineWidth(Float(lineWidth))
        addTMapPath(polyLines)
    }
}*/
//naver map
/*
extension NMFMapView {
    
    // 마커 hidden
    func hideMarker(_ markerId: String, hiddenValue: Bool, addedMarkers : [String:NMFMarker]) {
        
        let markers : [String:NMFMarker] = addedMarkers
        
        if let marker = markers[markerId]
        {
            //exist marker
            marker.hidden = hiddenValue
        }
        
    }
    
    // 마커 all hidden
    func hideAllMarker(_ hiddenValue: Bool, addedMarkers : [String:NMFMarker]) {
        
        let markers : [String:NMFMarker] = addedMarkers
        for (_, value) in markers {
            //exist marker
            value.hidden = hiddenValue
        }
    }
    func markerAnimate( marker : NMFMarker , orilat : CLongDouble, orilng : CLongDouble, dstlat : CLongDouble, dstlng : CLongDouble , duration : Double, timeInterval : Double)
    {
        var i : Double = 0
            
        let gaplat : CLongDouble = (orilat - dstlat)/(duration / timeInterval)
        let gaplng : CLongDouble = (orilng - dstlng)/(duration / timeInterval)
        
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (timer) in
            
            marker.position = NMGLatLng(lat: orilat - gaplat*CLongDouble(i), lng: orilng - gaplng*CLongDouble(i))
            
            i += 1
            
            if i > (duration / timeInterval)
            {
                timer.invalidate()
                
                i = 0
            }
        })
    }
    
    // 마커 추가 및 교체
    func addMarker(_ markerId: String, image: UIImage?, lon: Double, lat: Double, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 1), addedMarkers : [String:NMFMarker], animated: Bool = false) -> [String:NMFMarker] {
        
        var markers : [String:NMFMarker] = addedMarkers
        
        if let marker = markers[markerId]
        {
            //exist marker
            marker.hidden = false
            if let markerImage: UIImage = image
            {
                marker.iconImage = NMFOverlayImage.init(image: markerImage)
            }
            
            if !animated {
                marker.position = NMGLatLng(lat: lat, lng: lon)
            }
            else
            {
                self.markerAnimate(marker: marker, orilat: marker.position.lat, orilng: marker.position.lng, dstlat: lat, dstlng: lon, duration: 2.0, timeInterval: 0.016)
            }
        }
        else
        {
            //not exist marker
            let markerWithAnchor = NMFMarker(position: NMGLatLng(lat: lat, lng: lon))
            if let markerImage: UIImage = image
            {
                markerWithAnchor.iconImage = NMFOverlayImage.init(image: markerImage)
            }
            markerWithAnchor.anchor = anchorPoint
            markerWithAnchor.mapView = self
            markerWithAnchor.accessibilityLabel = markerId
            
            markers[markerId] = markerWithAnchor
            
        }
        
        return markers
        
    }
    
    func addMarker(_ markerId: String, image: String, lon: Double, lat: Double, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 1), addedMarkers : [String:NMFMarker]) -> [String:NMFMarker] {
        return addMarker(markerId, image: UIImage(named: image), lon: lon, lat: lat, anchorPoint: anchorPoint, addedMarkers:addedMarkers)
    }
    
    // 마커 추가 및 교체
    func addMarker(_ markerId: String, image: String, coordinate: CLLocationCoordinate2D, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 1), addedMarkers : [String:NMFMarker]) -> [String:NMFMarker] {
        return addMarker(markerId, image: image, lon: coordinate.longitude, lat: coordinate.latitude, anchorPoint: anchorPoint, addedMarkers:addedMarkers )
    }
    
    
    
    func zoomFit(key_value: mapCateogry, orgLon: Double, orgLat: Double, dstLon: Double, dstLat: Double, animated: Bool = true)
    {
        
        let keyValue = key_value
        switch keyValue {
        case .SELECT:

            //초기 맵 선택화면
            let bounds = NMGLatLngBounds(southWest: NMGLatLng(lat: orgLat, lng: orgLon),
                                          northEast: NMGLatLng(lat: dstLat, lng: dstLon))
            
            let EdgeInsets = UIEdgeInsets(top: 270, left: 40, bottom: 120, right: 40)
            let camUpdate = NMFCameraUpdate(fit: bounds, paddingInsets: EdgeInsets)
            
            camUpdate.animation = .fly
            camUpdate.animationDuration = 0.5
            self.moveCamera(camUpdate)
            
            let logo_EdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.logoMargin = logo_EdgeInsets
        
        case .DETAIL:

            //상세 핀 선택화면
            let position = NMFCameraPosition(NMGLatLng(lat: orgLat, lng: orgLon), zoom: 14)

            let camUpdate = NMFCameraUpdate(position: position)
            camUpdate.animation = .fly
            camUpdate.animationDuration = 0.8
            self.moveCamera(camUpdate)
            
            let logo_EdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.logoMargin = logo_EdgeInsets
           
        case .DRIVER:
            //여정보기 화면
            //출발 - 도착
            let bounds = NMGLatLngBounds(southWest: NMGLatLng(lat: orgLat, lng: orgLon),
                                          northEast: NMGLatLng(lat: dstLat, lng: dstLon))

            let EdgeInsets = UIEdgeInsets(top: 170, left: 120, bottom: 320, right: 120)
            let camUpdate = NMFCameraUpdate(fit: bounds, paddingInsets: EdgeInsets)
            
            camUpdate.animation = .fly
            camUpdate.animationDuration = 0.5
            self.moveCamera(camUpdate)

            let logo_EdgeInsets = UIEdgeInsets(top: UIScreen.main.bounds.height*0.53, left: 0, bottom: 0, right: 0)
            self.logoMargin = logo_EdgeInsets
           
        case .DRIVER_COMING:
            //여정보기 화면
            //출발 - 차량
            let bounds = NMGLatLngBounds(southWest: NMGLatLng(lat: orgLat, lng: orgLon),
                                          northEast: NMGLatLng(lat: dstLat, lng: dstLon))

            let EdgeInsets = UIEdgeInsets(top: 170, left: 120, bottom: 320, right: 120)
            let camUpdate = NMFCameraUpdate(fit: bounds, paddingInsets: EdgeInsets)
            
            camUpdate.animation = .fly
            camUpdate.animationDuration = 0.5
            self.moveCamera(camUpdate)

            let logo_EdgeInsets = UIEdgeInsets(top: UIScreen.main.bounds.height*0.53, left: 0, bottom: 0, right: 0)
            self.logoMargin = logo_EdgeInsets
        
        case .DRIVER_DEPARTURE:
            //여정보기 화면
            let bounds = NMGLatLngBounds(southWest: NMGLatLng(lat: orgLat, lng: orgLon),
                                          northEast: NMGLatLng(lat: dstLat, lng: dstLon))

            let EdgeInsets = UIEdgeInsets(top: 170, left: 120, bottom: 320, right: 120)
            let camUpdate = NMFCameraUpdate(fit: bounds, paddingInsets: EdgeInsets)
            
            camUpdate.animation = .fly
            camUpdate.animationDuration = 0.5
            self.moveCamera(camUpdate)

            let logo_EdgeInsets = UIEdgeInsets(top: UIScreen.main.bounds.height*0.53, left: 0, bottom: 0, right: 0)
            self.logoMargin = logo_EdgeInsets
            
        case .RESERVE:
            
            //예약, 배차완료 화면 (옵션, 서비스 선택)
            let bounds = NMGLatLngBounds(southWest: NMGLatLng(lat: orgLat, lng: orgLon),
                                          northEast: NMGLatLng(lat: dstLat, lng: dstLon))
            
            let EdgeInsets = UIEdgeInsets(top: 140, left: 65, bottom: UIScreen.main.bounds.height*0.57, right: 65)
            let camUpdate = NMFCameraUpdate(fit: bounds, paddingInsets: EdgeInsets)
            
            camUpdate.animation = .fly
            camUpdate.animationDuration = 0.5
            self.moveCamera(camUpdate)

            let logo_EdgeInsets = UIEdgeInsets(top: UIScreen.main.bounds.height*0.4, left: 0, bottom: 0, right: 0)
            self.logoMargin = logo_EdgeInsets
            
//        default:
//
//            let position = NMFCameraPosition(NMGLatLng(lat: orgLat, lng: orgLon), zoom: 14)
//
//            let camUpdate = NMFCameraUpdate(position: position)
//            camUpdate.animation = .easeIn
//            camUpdate.animationDuration = 0.5
//            self.moveCamera(camUpdate)
        }
        
        
        
    }
    //zoom in
    func zoomIn(orgLon: Double, orgLat: Double, zoomlevel: Double = 14)
    {
        
         let position = NMFCameraPosition(NMGLatLng(lat: orgLat, lng: orgLon), zoom: zoomlevel)

         let camUpdate = NMFCameraUpdate(position: position)
         camUpdate.animation = .fly
         camUpdate.animationDuration = 0.8
         self.moveCamera(camUpdate)
        
    }
    // 맵 이동
    func setCenter(lon: Double, lat: Double, animated: Bool = true) {
        let camUpdate = NMFCameraUpdate(position: NMFCameraPosition(NMGLatLng(lat: lat, lng: lon), zoom: 14, tilt: 0, heading: 0))
        camUpdate.animation = .linear
        camUpdate.animationDuration = 0.3
        self.moveCamera(camUpdate)
    }
    
    // 예상 경로 표시
    func addTMapPath(_ features: [Feature], color: UIColor, lineWidth: CGFloat) {

        var coords : [NMGLatLng] = []
        for feature in features {
            if let geometry = feature.geometry, let coordinates = geometry.coordinates
            {
                for coordinate in coordinates {
                    coords.append(NMGLatLng(lat: coordinate[1], lng: coordinate[0]))
                }
            }
        }
        
        if let pathOverlay = NMFPath(points: coords) {
            pathOverlay.width = lineWidth
            pathOverlay.color = color
            pathOverlay.mapView = self
        }
    }

    func addMapPath_removeBefore(_ pathId: String, features: [Feature], color: UIColor, lineWidth: CGFloat, addedPaths : [String:NMFPath]) -> [String:NMFPath] {

        var paths : [String:NMFPath] = addedPaths
        
        if let path = paths[pathId]
        {
            //exist path
            //remove and draw
            path.mapView = nil
        }
        else
        {
            //not exist path
            //just draw
        }
        var coords : [NMGLatLng] = []
        for feature in features {
            if let geometry = feature.geometry, let coordinates = geometry.coordinates
            {
                for coordinate in coordinates {
                    coords.append(NMGLatLng(lat: coordinate[1], lng: coordinate[0]))
                }
            }
        }
        
        if let pathOverlay = NMFPath(points: coords) {
            pathOverlay.width = lineWidth
            pathOverlay.color = color
            pathOverlay.mapView = self
            
            paths[pathId] = pathOverlay
        }
        
        
        return paths
    }
    // 맵 경로 제거
    func removeMapPath(_ pathId: String, addedPaths : [String:NMFPath]) -> [String:NMFPath] {
        var paths : [String:NMFPath] = addedPaths
        
        if let path = paths[pathId]
        {
            path.mapView = nil
            paths.removeValue(forKey: pathId)
        }
        
        return paths
        
    }
    // 예상 경로 표시
    func addTMapPath(_ positions: [Position]?, color: UIColor, lineWidth: CGFloat) {
        
        var coords : [NMGLatLng] = []
        if let positions = positions {
            for position in positions {
                if let lon = position.lon, let lat = position.lat {
                    coords.append(NMGLatLng(lat: lat, lng: lon))
                }
            }
        }
        
        if let pathOverlay = NMFPath(points: coords) {
            pathOverlay.width = lineWidth
            pathOverlay.color = color
            pathOverlay.mapView = self
        }
    }
    
    // 맵 마커 제거
    func removeMarkerWithKey(_ markerId: String, addedMarkers : [String:NMFMarker]) {
        
        if let marker = addedMarkers[markerId]
        {
            marker.mapView = nil
        }
    }
    
    //맵 옵션값 변경
    func trimMapSetting(mapType : NewSelectMapViewController.MapOperateType) {
        switch mapType {
        case .defaultMap:
        
            self.allowsRotating = true
            self.allowsTilting = true
            self.isZoomGestureEnabled = true
            self.extent = nil
            self.fixExtent(needFix: false)

            break
            
        case .selectDetailpoint:
            
            //상세 위치선택 화면에서 맵의 회전 막기
            self.allowsRotating = false
            self.allowsTilting = false
            self.fixExtent(needFix: false)
            
            break
            
        case .readyAllocation:
            
            self.isZoomGestureEnabled = true
            self.fixExtent(needFix: false)
            
            break
            
        }
    }
    
    //맵 고정
    func fixExtent(needFix : Bool) {
        
        if needFix
        {
            self.extent = NMGLatLngBounds(southWestLat: self.latitude, southWestLng: self.longitude, northEastLat: self.latitude+0.0000000000001, northEastLng: self.longitude+0.0000000000001)
        }
        else
        {
            self.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
//            self.extent = nil
        }
        
    }
    
}*/

protocol StringType {
    var isEmpty: Bool { get }
}

extension String : StringType { }

protocol CollectionType {
    var isEmpty: Bool { get }
}

extension Array : CollectionType { }

extension Optional where Wrapped: StringType {
    var isNullOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension Optional where Wrapped: CollectionType {
    var isNullOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension UITextField {

    typealias ToolbarItem = (title: String, target: Any, selector: Selector)

    func addToolbar(leading: [ToolbarItem] = [], trailing: [ToolbarItem] = []) {
        let toolbar = UIToolbar()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let leadingItems = leading.map { item in
            return UIBarButtonItem(title: item.title, style: .plain, target: item.target, action: item.selector)
        }

        let trailingItems = trailing.map { item in
            return UIBarButtonItem(title: item.title, style: .plain, target: item.target, action: item.selector)
        }

        var toolbarItems: [UIBarButtonItem] = leadingItems
        toolbarItems.append(flexibleSpace)
        toolbarItems.append(contentsOf: trailingItems)

        toolbar.setItems(toolbarItems, animated: false)
        toolbar.sizeToFit()

         self.inputAccessoryView = toolbar
    }
}

struct Stack<T>
{
    private var elements = Array<T>()

    @discardableResult
    public mutating func pop() -> T?
    {
        return self.elements.popLast()
    }

    public mutating func push(element: T)
    {
        self.elements.append(element)
    }

    public func peek() -> T?
    {
        return self.elements.last
    }

    public func elementAt(index: Int) -> T?
    {
        return self.elements[index]
    }

    public var isEmpty: Bool
    {
        return self.elements.isEmpty
    }

    public var count: Int
    {
        return self.elements.count
    }

    public var lastIndex: Int
    {
        return self.elements.count - 1
    }

    public mutating func removeAll()
    {
        self.elements.removeAll()
    }

    @discardableResult
    public mutating func removeAt(index: Int) -> T?
    {
        return self.elements.remove(at: index)
    }
}

extension UIWindow {
    public var visibleViewController: UIViewController? {
        return self.visibleViewControllerFrom(vc: self.rootViewController)
    }
    public func visibleViewControllerFrom(vc: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nc = vc as? UINavigationController
        {
            return self.visibleViewControllerFrom(vc: nc.visibleViewController)
        }
        else if let tc = vc as? UITabBarController
        {
            return self.visibleViewControllerFrom(vc: tc.selectedViewController)
        }
        else
        {
            if let pvc = vc?.presentedViewController
            {
                return self.visibleViewControllerFrom(vc: pvc)
            }
            else
            {
                return vc
            }
        }
    }
}

class TAUtil {
    
    // 업데이트 필요 시 true 리턴
    class func getProfileImageUrlString(_ file_bundle: String?, index: Int) -> String {
        
        if file_bundle == nil
        {
            return TAUtil.getBaseServerUrl() + "/html/img/" + TAConstants.IMG_PROFILE_NAME
        }
        else
        {
            let arr = file_bundle!.components(separatedBy: ",")
            if arr.count-1 >= index
            {
                return TAUtil.getGcpImageServerUrl() + arr[index]
            }
            else
            {
                return TAUtil.getBaseServerUrl() + "/html/img/" + TAConstants.IMG_PROFILE_NAME
            }
        }
    }
    
    class func getMiddleBannerImageUrlString(_ file_bundle: String?, index: Int) -> String {
        
        if file_bundle == nil
        {
            return TAUtil.getBaseServerUrl() + "/html/img/" + TAConstants.IMG_MIDDLE_BANNER_NAME
        }
        else
        {
            let arr = file_bundle!.components(separatedBy: ",")
            if arr.count-1 >= index
            {
                return TAUtil.getGcpImageServerUrl() + arr[index]
            }
            else
            {
                return TAUtil.getBaseServerUrl() + "/html/img/" + TAConstants.IMG_MIDDLE_BANNER_NAME
            }
        }

    }
    
    class func getBottomBannerImageUrlString(_ file_bundle: String, index: Int) -> String {
        
        let arr = file_bundle.components(separatedBy: ",")
        if arr.count-1 >= index
        {
            return TAUtil.getGcpImageServerUrl() + arr[index]
        }
        else
        {
            return TAUtil.getBaseServerUrl() + "/html/" + TAConstants.IMG_BOTTOM_BANNER_NAME
        }

    }
    
    class func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    // 베이스 서버 URL
    class func getBaseServerUrl() -> String {
        if let baseUrl = TAGlobalManager.sharedInstance.baseUrl {
            return baseUrl
        } else if TAGlobalManager.isProd {
            return TAConstants.REAL_SERVER_BASE_URL
        } else {
            return TAConstants.DEV_SERVER_BASE_URL
        }
    }
    
    // GCP 이미지 서버 URL
    class func getGcpImageServerUrl() -> String {
        if TAGlobalManager.isProd {
            return TAConstants.REAL_GCP_IMG_URL
        } else {
            return TAConstants.DEV_GCP_IMG_URL
        }
    }
    
    // get UUID
    /*class func getUUID() -> String {
        let wrapper = KeychainItemWrapper(identifier: "UUID", accessGroup: nil)
        
        guard let uuid = wrapper?.object(forKey: kSecAttrAccount) as? String, uuid.count > 0 else {
            let uuid = UIDevice.current.identifierForVendor?.uuidString.replacingOccurrences(of: "-", with: "")
            
            wrapper?.setObject(uuid, forKey: kSecAttrAccount)
            
            return uuid!
        }
        
        return uuid
    }*/
    
    // ADID enabled
    class func isAdvertisingTrackingEnabled() -> Bool {
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled
    }
    
    // get ADID
    class func getADID() -> String {
        //return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if TARGET_OS_SIMULATOR != 0
        {
            //simulator
            return "aabc1234-a12b-a123-abcd-abcde1234567"
        }
        else
        {
            //device
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
    }
    
    // 앱 버전 가져오기
    class func getAppVersion() -> String {
        //let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        return TAConstants.SDK_VERSION //bundle?.infoDictionary!["CFBundleShortVersionString"] as! String
        //return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    // 앱 빌드번호 가져오기
    class func getAppBuildNumber() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    // OS 버전 가져오기
    class func getOsVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    // 모델 정보 가져오기
    class func getModel() -> String {
        var systemInfo = utsname()
        
        uname(&systemInfo)
        let size = Int(_SYS_NAMELEN) // is 32, but posix AND its init is 256....
        
        let s = withUnsafeMutablePointer(to: &systemInfo.machine) { p in
            p.withMemoryRebound(to: CChar.self, capacity: size) { p2 in
                return String(cString: p2)
            }
        }
        
        return s
    }
    
    // 네비게이션 컨트롤러 가져오기
    class func getNavigationController() -> UINavigationController? {
        var window: UIWindow?
        
        if UIApplication.shared.windows.count > 0 {
            window = UIApplication.shared.windows[0]
        }
        
        if let controller = window?.rootViewController
        {
            NSLog("getNavigationController root : " + controller.description)
        }
        
        return window?.rootViewController as? UINavigationController
    }

    // 베이스 서버 URL
    /*class func getBaseServerUrl() -> String {
        if let baseUrl = MCGlobalManager.sharedInstance.baseUrl {
            return baseUrl
        } else if TAConstants.IS_DEV {
            return TAConstants.DEV_SERVER_BASE_URL
        } else {
            return TAConstants.REAL_SERVER_BASE_URL
        }
    }*/
    
    // 버전 비교
    // 업데이트 필요 시 true 리턴
    class func compareVersion(_ version: String) -> Bool {
        let localVersion = getAppVersion().components(separatedBy: ".")
        let serverVersion = version.components(separatedBy: ".")
        
        for i in 0..<max(localVersion.count, serverVersion.count) {
            let local = Int(i < localVersion.count ? localVersion[i] : "0") ?? 0
            let server = Int(i < serverVersion.count ? serverVersion[i] : "0") ?? 0
            
            if local < server {
                return true
            } else if local > server {
                return false
            }
        }
        
        return false
    }
    
    // 공유하기
    class func shareContent(_ parent: UIViewController, content: String) {
        let objectsToShare = [content]
        let vc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        parent.present(vc, animated: true, completion: nil)
    }
    
    // 전화걸기
    class func callTel(_ number: String) {
        if let url = URL(string: "tel:\(number)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // Firebase Analytics
    // event action
    class func logEvent(_ eventName: String, category: String, action: String, label: String? = nil) {
        var param = ["category": category, "action": action] as [String: Any]
        
        if let label = label {
            param["label"] = label
        }
        
        //Analytics.logEvent(eventName, parameters: param)
//        printd("eventName = \(eventName), category = \(category), action = \(action), label = \(label)")
    }
    
    // event login
    class func logEventLogin(_ action: String) {
        //logEvent(AnalyticsEventLogin, category: "로그인", action: action)
    }
    
    // event signup
    class func logEventSignup(_ action: String) {
        //logEvent(AnalyticsEventSignUp, category: "회원가입", action: action)
    }
    
    // screen
    class func setScreen(_ screenName: String, className: String) {
        //Analytics.setScreenName(screenName, screenClass: className)
    }
    
    // 하단 인디케이터 높이
    class func getBottomHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows[0].safeAreaInsets.bottom
        } else {
            return 0
        }
    }
    
    // 타이틀 suffix
    class func getServiceSuffix() -> String {
        if TAGlobalManager.isProd {
            return "(\(getAppBuildNumber()))"
        } else {
            return ""
        }
    }
}
