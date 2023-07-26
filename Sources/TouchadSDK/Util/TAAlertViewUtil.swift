//
//  TAAlertViewUtil.swift
//  touchad
//
//  Created by shimtaewoo on 2020/11/04.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class TAAlertViewUtil: NSObject {
    class func showAlert(_ parent: UIViewController, title: String? = nil, message: String? = nil, confirmTextIsMint: Bool = false, confirmText: String? = TAConstants.COMMON_CONFIRM_TITLE, confirmHandler: (() -> Void)? = nil, cancelText: String? = nil, cancelHandler: (() -> Void)? = nil) {
        parent.view.isUserInteractionEnabled = true
        if cancelText == nil {
            if title == nil {
                CommonPopupView.createView(parent.view, title: "알림", text: message ?? "", confirmText: confirmText, confirmAction: confirmHandler)
            } else {
                CommonPopupView.createView(parent.view, title: title!, text: message ?? "", confirmText: confirmText, confirmAction: confirmHandler)
            }
        } else {
            if title == nil {
                PromptCommonPopupView.createView(parent.view, title: "알림", text: message ?? "", confirmText: confirmText,
                    confirmAction: {() in
                        /*let msg = message ?? ""
                        if msg.contains(TAConstants.CARD_INSERT_GUIDE_TRIGGER) {
                            
                            let usrIdx = TAGlobalManager.userInfo["usr_idx"] as! Int
                            let isSignup = TAConstants.CARD_INSERT_WHEN_MY_PAGE
                         
                            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
                            let vc = CardCaptureViewController(nibName: "CardCaptureViewController", bundle: bundle)
                            
                            vc.cardUsrIdx = usrIdx
                            vc.cardIsSignUp = isSignup
                            if let navigationController = parent.navigationController
                            {
                                navigationController.pushViewController(vc, animated: true)
                            }
                            else
                            {
                                parent.dismiss(animated: false, completion: {() in
                                    let pvc : PopupWebViewController = (parent as? PopupWebViewController)!
                                    pvc.openerViewController?.navigationController?.pushViewController(vc, animated: true)
                                    
                                })
                            }
                            
                        }*/
                       
                    },
                    cancelText: cancelText, cancelAction: {() in
                        if let navigationController = parent.navigationController
                        {
                            navigationController.popViewController(animated: true)
                        }
                        else
                        {
                            parent.dismiss(animated: true, completion: nil)
                        }
                    })
            } else {
                PromptCommonPopupView.createView(parent.view, title: title ?? "알림", text: message ?? "", confirmText: confirmText, confirmAction: confirmHandler, cancelText: cancelText, cancelAction: cancelHandler)
            }
        }
    }
    
    class func showAlertWithTextField(_ parent: UIViewController, title: String?, message: String?, defaultText: String?, confirmText: String, confirmHandler: ((UIAlertAction, String?) -> Void)? = nil, cancelText: String, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        parent.view.isUserInteractionEnabled = true
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: confirmText, style: .default) { (action) in
            if let confirmHandler = confirmHandler {
                confirmHandler(action, alert.textFields![0].text)
            }
        }
        let cancel = UIAlertAction(title: cancelText, style: .cancel, handler: cancelHandler)
        
        alert.addTextField { (textField) in
            textField.text = defaultText
        }
        alert.addAction(confirm)
        alert.addAction(cancel)
        parent.present(alert, animated: true, completion: nil)
    }
}
