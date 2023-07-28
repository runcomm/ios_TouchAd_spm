//
//  TAWebViewDelegate.swift
//  touchad
//
//  Created by shimtaewoo on 2020/11/04.
//  Copyright © 2020 developer. All rights reserved.
//
import UIKit
import WebKit

@objc protocol TAWebViewInterface {
//    func sendUserInfo(autoYn: Bool, id: String, password: String, pushYn: Bool)
//    func autoLogin(autoYn: Bool, id: String)
//    func onPush(_ pushYn: Bool)
//    func loadingBar(_ showYn: Bool)
//    func callUserInfo()
//    func openBrowser(_ url: String?)
      @objc optional func setNavigationStatus(_ urlString: String)
      @objc optional func setTitleString(_ urlString: String)
      @objc optional func attachPopupView(child: UIViewController)
      @objc optional func detachPopupView()
}

class TAWebViewDelegate: NSObject, WKUIDelegate, WKNavigationDelegate {
    private let viewController: (UIViewController & NetworkManagerDelegate & TAWebViewInterface)
    
    init(_ vc: UIViewController & NetworkManagerDelegate & TAWebViewInterface) {
        viewController = vc
    }
    
    //String형 스택을 정적 변수로 선언
    static var urlStack = Stack<String>()

    //정적함수로 url 값이 들어오면 무조건 push한 뒤 histroy back상황이 발생하거나 url값에 #이 붙는 상황을 분기처리하는 곳
    static func updateUrlStack(url : String)
    {
        urlStack.push(element: url)

        //url값 문자열 마지막에 #이 붙을 때 pop 처리
        if (url.lastString == "#")
        {
            urlStack.pop()
        }

        //history back 상황 처리
        if (urlStack.count > 2)
        {
            if (urlStack.peek() == urlStack.elementAt(index: urlStack.lastIndex - 2))
            {
                urlStack.pop()
                urlStack.pop()
            }
        }
    }
    
    //MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let urlString = navigationAction.request.url?.absoluteString else {
            decisionHandler(.cancel)
            return
        }
        
        printd("decidePolicyForNavigationAction = \(urlString)")
        
        if urlString.hasPrefix("touchadjs://") {
            TAGlobalManager.goDeepLink(viewController, deepLink: urlString)
            decisionHandler(.cancel)
        } else if urlString.hasPrefix("tel:") || urlString.hasPrefix("mailto:") || urlString.hasPrefix("kakaolink://") {
            // 카카오톡 연동 추가
            if let url = URL(string: urlString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
            decisionHandler(.cancel)
        }
        else if let url = navigationAction.request.url, url.scheme != "http" && url.scheme != "https" {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            decisionHandler(.cancel)
        }
        else if navigationAction.navigationType == .linkActivated , urlString.contains(TAConstants.VIDEO_EXTERNAL_HOST_PREFIX)
        {
            if let urlObj = URL(string: urlString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(urlObj)
                } else {
                    UIApplication.shared.openURL(urlObj)
                }
            }
            decisionHandler(.cancel)
        }
        else
        {
            viewController.setNavigationStatus?(urlString)
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        printd("didStartProvisionalNavigation")
        viewController.startIndicator()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        printd("didReceiveServerRedirectForProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        printd("didCommit")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        printd("didFinish")
        
        //중복터치 방지 함수 호출
        //onPageFinishedTouchAd(url: webView.url?.absoluteString)
        //printd("urlStack : \(TAWebViewDelegate.urlStack)")
        
        viewController.stopIndicator()
        viewController.setTitleString?(webView.title ?? "")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        printd("didFail = \(error)")
        viewController.stopIndicator()
        if error._code == NSURLErrorCancelled
        {
            viewController.setTitleString?(webView.title ?? "")
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        printd("didFailProvisionalNavigation = \(error)")
        viewController.stopIndicator()
        
        if(viewController.navigationController != nil)
        {
           
            if let errorViewcontroller = viewController.navigationController!.topViewController as? ErrorViewController
            {
                
            }
            else
            {
                let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
                let evc = ErrorViewController(nibName: "ErrorViewController", bundle: Bundle.module)
                evc.errorCode = "-1009"
                viewController.navigationController?.pushViewController(evc, animated: false)
            }
        }
        
    }
    
    //MARK: - WKUIDelegate
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        TAAlertViewUtil.showAlert(viewController, title: nil, message: message, confirmText: TAConstants.COMMON_CONFIRM_TITLE, confirmHandler: {
            completionHandler()
        })
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let completionHandlerWrapper = CompletionHandlerWrapper(completionHandler: completionHandler, defaultValue: false)
        TAAlertViewUtil.showAlert(viewController, title: nil, message: message, confirmText: TAConstants.COMMON_CONFIRM_TITLE, confirmHandler: {
            completionHandlerWrapper.respondHandler(true)
            //completionHandler(true)
        }, cancelText: TAConstants.COMMON_CANCEL_TITLE) {
            completionHandlerWrapper.respondHandler(false)
            //completionHandler(false)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        TAAlertViewUtil.showAlertWithTextField(viewController, title: nil, message: prompt, defaultText: defaultText, confirmText: TAConstants.COMMON_CONFIRM_TITLE, confirmHandler: { (action, text) in
            completionHandler(text)
        }, cancelText: TAConstants.COMMON_CANCEL_TITLE) { (action) in
            completionHandler(nil)
        }
    }
    
    //window.open
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil
        {
            if let urlString = navigationAction.request.url?.absoluteString, let url = URL(string: urlString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            return nil
        }
        else
        {
            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
            let vc = CommonWebViewController(nibName: "CommonWebViewController", bundle: bundle)
            //vc.titleName = "TOUCH AD"
            vc.url = navigationAction.request.url?.absoluteString
            viewController.attachPopupView?(child: vc)
            return vc.webView
        }
    }
    
    //window.close
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        viewController.detachPopupView!()
    }
    
    //중복터치 방지 처리를 정의하는 함수
    private func onPageFinishedTouchAd(url: String?) {
        if (url != nil)
        {
            TAWebViewDelegate.updateUrlStack(url: url!)

            if (TAWebViewDelegate.urlStack.count > 1)
            {
                let previousLastIndex = TAWebViewDelegate.urlStack.lastIndex - 1
                let lastIndexUrl = TAWebViewDelegate.urlStack.peek()

                let lastIndexUrlCheck = TAWebViewDelegate.urlStack.elementAt(index: previousLastIndex)?.contains(TAConstants.WEBURL_ADVERTISE_SELECT_CHARGING)
                let currentUrlCheck = lastIndexUrl?.contains(TAConstants.WEBURL_ADVERTISE_SELECT_CHARGING)

                //마지막에 쌓인 스택과 바로 전단계에 쌓인 스택의 url이 광고상세화면인지 체크하여 true일 경우(중복상황발생)
                //중복화면 이전으로 돌아가도록 하는 코드
                if (lastIndexUrlCheck! && currentUrlCheck!)
                {
                    viewController.navigationController?.popViewController(animated: true)
                }
            }

            //URL_MOVIE_STOP이 스택에 쌓일 경우 pop 처리를 하는 코드
            //URL_MOVIE_STOP : 전면 동영상 광고를 소리를 킨 상태로 도중에 종료를 할 때 소리가 유지되는 것을 막아주는 Url
            if (TAWebViewDelegate.urlStack.peek() == TAConstants.URL_MOVIE_STOP) {
                TAWebViewDelegate.urlStack.pop()
            }

        }
    }
}

class CompletionHandlerWrapper<Element> {
  private var completionHandler: ((Element) -> Void)?
  private let defaultValue: Element

  init(completionHandler: @escaping ((Element) -> Void), defaultValue: Element) {
    self.completionHandler = completionHandler
    self.defaultValue = defaultValue
  }

  func respondHandler(_ value: Element) {
    completionHandler?(value)
    completionHandler = nil
  }

  deinit {
    respondHandler(defaultValue)
  }
}
