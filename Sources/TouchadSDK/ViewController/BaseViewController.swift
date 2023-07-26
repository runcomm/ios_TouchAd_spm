//
//  BaseViewController.swift
//  touchad
//
//  Created by shimtaewoo on 2020/08/19.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
// import SnapKit

class BaseViewController: UIViewController, NetworkManagerDelegate {
    
    @IBOutlet weak var titleContainerView: UIView?
    @IBOutlet weak var titleLabel: UILabel?
    
    private let indicator = UIActivityIndicatorView()
    private var keyboardShown = false
    /*
    private lazy var transition: CircleTransition = {
        let transition = CircleTransition()
        transition.startPoint = self.view.center
        transition.circleColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.3)
        return transition
    }()
    */
    private lazy var transition: AlphaTransition = {
        let transition = AlphaTransition()
        return transition
    }()
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // firebase analytics
        TAUtil.setScreen(screenName(), className: simpleClassName)
    }
    
    //MARK: - Private
    
    private func createIndicator() {
        indicator.isHidden = true
        //indicator.style = .white
        if #available(iOS 13.0, *) {
            indicator.style = .medium
        } else {
            // Fallback on earlier versions
        }
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
//        self.view.addSubview(indicator)
//        indicator.snp.makeConstraints { (make) in
//            make.center.equalTo(self.view.snp.center)
//        }
    }
    
    @objc private func keyboardWillShow(noti: NSNotification) {
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardSize.height == 0 {
                return
            }
            
            if keyboardShown {
                self.updateKeyboardShow(height: keyboardSize.height)
                return
            }
            
            keyboardShown = true
            UIView.animate(withDuration: 0.3, animations: {
                self.animateKeyboardWillShow(height: keyboardSize.height)
            })
        }
    }
    
    @objc private func keyboardWillHide(noti: NSNotification) {
        if !keyboardShown {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.animateKeyboardWillHide()
        }, completion: { (finished) in
            self.keyboardShown = false
        })
    }
    
    //MARK: - Public
    
    /*func getParent() -> MainTabBarController? {
        return parent as? MainTabBarController
    }*/
    func getParent() -> UINavigationController? {
        return parent as? UINavigationController
    }
    
    func startIndicator() {
//        if let parent = getParent() {
//            //parent.startIndicator()
//            printd("test1")
//        } else {
//            self.view.isUserInteractionEnabled = false;
//            indicator.isHidden = false;
//            self.view.bringSubviewToFront(indicator)
//            indicator.startAnimating()
//        }
        self.view.isUserInteractionEnabled = false;
        indicator.isHidden = false;
        self.view.bringSubviewToFront(indicator)
        indicator.startAnimating()
    }
    
    func stopIndicator() {
//        if let parent = getParent() {
//            //parent.stopIndicator()
//        } else {
//            self.view.isUserInteractionEnabled = true;
//            indicator.isHidden = true
//            indicator.stopAnimating()
//        }
        self.view.isUserInteractionEnabled = true;
        indicator.isHidden = true
        indicator.stopAnimating()
    }
    
    func displayPush(_ body: String, deepLink: String?) {
        //PushView.createView(self, body: body, deepLink: deepLink)?.show()
    }
    
    /*func getTitleView() -> TitleView? {
        if let titleContainerView = titleContainerView, titleContainerView.subviews.count > 0, let titleView = titleContainerView.subviews[0] as? TitleView {
            return titleView
        }
        
        return nil
    }*/
    
    //MARK: - Override
    
    // 키보드가 보여지고 있고 높이가 변경됐을 때 실행되는 함수(서브 클래스에서 구현)
    func updateKeyboardShow(height: CGFloat) {
        
    }
    
    // 키보드가 보여질 때 애니메이션 함수(서브 클래스에서 구현)
    func animateKeyboardWillShow(height: CGFloat) {
        
    }
    
    // 키보드가 감춰질 때 함수(서브 클래스에서 구현)
    func animateKeyboardWillHide() {
        
    }
    
    // 스트린명(서브 클래스에서 구현)
    func screenName() -> String {
        return ""
    }
    
    //MARK: - NetworkManagerDelegate
    
    func showAlert(_ msg: String) {
        if let parent = getParent() {
            TAAlertViewUtil.showAlert(parent, title: TAConstants.COMMON_POPUP_TITLE, message: msg)
        } else {
            TAAlertViewUtil.showAlert(self, title: TAConstants.COMMON_POPUP_TITLE, message: msg)
        }
    }
    
    func showAlert(_ msg: String, _ handler: (() -> Void)? = nil) {
        if let parent = getParent() {
            TAAlertViewUtil.showAlert(parent, title: TAConstants.COMMON_POPUP_TITLE, message: msg, confirmHandler: handler)
        } else {
            TAAlertViewUtil.showAlert(self, title: TAConstants.COMMON_POPUP_TITLE, message: msg, confirmHandler: handler)
        }
    }
    
    func showAlert(_ title: String, _ msg: String, _ handler: (() -> Void)? = nil) {
        if let parent = getParent() {
            TAAlertViewUtil.showAlert(parent, title: title, message: msg, confirmHandler: handler)
        } else {
            TAAlertViewUtil.showAlert(self, title: title, message: msg, confirmHandler: handler)
        }
    }
    
    func showAlert(_ title: String, _ msg: String, _ confirmButton: String, _ handler: (() -> Void)? = nil) {
        if let parent = getParent() {
            TAAlertViewUtil.showAlert(parent, title: title, message: msg, confirmText: confirmButton, confirmHandler: handler)
        } else {
            TAAlertViewUtil.showAlert(self, title: title, message: msg, confirmText: confirmButton, confirmHandler: handler)
        }
    }
    
    func dismissAlert(_ parant: UIView) {
        /*for view in parant.subviews {
            if view is CommonPopupView
            {
                view.removeFromSuperview();
            }
            else if view is PromptCommonPopupView
            {
                view.removeFromSuperview();
            }
            
        }*/
        view.removeFromSuperview();
    }

    func showErrorAndRefreshAccessToken(_ response : BaseResponse?, _ error : Error?, _ isProcess : Bool)
    {
        if let response = response
        {
            if response.result == TAConstants.ACCESS_TOKEN_EXPIRE_ERROR
            {
                //self.showAlert(TAConstants.ACCESS_TOKEN_REFRESH_TITLE){() in

                    let platformId = TAGlobalManager.platformId
                    NetworkRequest.requestJWTRefresh(self, mbrId: TAGlobalManager.mbrId, platformId: platformId, success: {(response) in
                        if let user = response.data?[0] as User? {
                            TAGlobalManager.accessToken = user.accessToken ?? ""
                            self.viewWillAppear(false)
                        }
                    }, failure: {(response, error, isProcess) in
                        self.showAlert(TAConstants.ACCESS_TOKEN_REFRESH_ERROR)
                    })
                    
                //}
            }
            else
            {
                self.showAlert(response.error!)
            }
        }
        else
        {
            self.showAlert(TAConstants.NETWORK_ERROR_MESSAGE)
        }
    }
    
    func reloadWebView(){
        
    }
    
    func goNavigationLink(){
        
    }
    
    func goBack(depth: Int, webUrlStr: String?) {
        
    }
}

extension BaseViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        return transition
    }
}
