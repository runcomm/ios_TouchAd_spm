//
//  BottomAppPushPopupView.swift
//  TouchadSDK
//
//  Created by 이윤표 on 2023/05/12.
//

import UIKit

class BottomAppPushPopupView : UIView {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var appPushSwitch: UISwitch!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancleLabel: UILabel!
    var confirmAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    class func createView(_ parent: UIView, _ appPushYn: String? = nil, confirmAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        guard let view = bundle?.loadNibNamed("BottomAppPushPopupView", owner: parent, options: nil)?[0] as? BottomAppPushPopupView else {
            printd("fail to load view")
            return
        }
        
        view.appPushSwitch.isOn = appPushYn == TAConstants.YES
        view.confirmAction = confirmAction
        view.cancelAction = cancelAction
        view.appPushSwitch.backgroundColor = UIColor.rgb(213, 213, 213)
        view.appPushSwitch.onTintColor = UIColor.rgb(50, 3, 202)
        view.appPushSwitch.layer.cornerRadius = 16
        
        if (view.appPushSwitch.isOn)
        {
            view.confirmButton.backgroundColor = UIColor.rgb(63, 24, 190)
            view.confirmButton.isEnabled = true
        }
        else
        {
            view.confirmButton.backgroundColor = UIColor.rgb(163, 163, 163)
            view.confirmButton.isEnabled = false
        }
        
        
        
        parent.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(parent)
        }
        
        view.popupView.frame.origin.y = view.frame.size.height
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,  animations: {
            view.popupView.frame.origin.y = view.frame.size.height - view.popupView.frame.size.height
        })
    }
    
    @IBAction func clickAppPushSwitch(_ sender: UISwitch) {
        if sender.isOn
        {
            TAGlobalManager.isAppPush = true
            confirmButton.backgroundColor = UIColor.rgb(63, 24, 190)
            confirmButton.isEnabled = true
        }
        else
        {
            TAGlobalManager.isAppPush = false
            confirmButton.backgroundColor = UIColor.rgb(163, 163, 163)
            confirmButton.isEnabled = false
        }
        
    }
    
    // MARK: - IBAction
    
    @IBAction func clickConfirm(_ sender: UIButton) {
        confirmAction?()
        dismiss()
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        cancelAction?()
        dismiss()
    }

    private func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,  animations: {
            self.popupView.frame.origin.y = self.frame.size.height
            self.cancleLabel.frame.origin.y = self.frame.size.height
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

}
