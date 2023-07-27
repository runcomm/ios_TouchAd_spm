//
//  PromptCommonPopupView.swift
//  touchad
//
//  Created by shimtaewoo on 2020/09/09.
//  Copyright © 2020 developer. All rights reserved.
//
import UIKit
// import SnapKit

class PromptCommonPopupView: UIView, Modal {
    var backgroundView: UIView = UIView()
    var dialogView: UIView = UIView()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var confirmAction: (() -> Void)?
    private var cancelAction: (() -> Void)?

    class func createView(_ parent: UIView, title: String, text: String = "", textAlign: NSTextAlignment = .left, confirmText: String? = TAConstants.COMMON_CONFIRM_TITLE, confirmAction: (() -> Void)? = nil, cancelText: String? = TAConstants.COMMON_CANCEL_TITLE, cancelAction: (() -> Void)? = nil) {
        //guard let view = Bundle.main.loadNibNamed("PromptCommonPopupView", owner: parent)?[0] as?
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        guard let view = Bundle.module.loadNibNamed("PromptCommonPopupView", owner: parent, options: nil)?[0] as? PromptCommonPopupView else {
            printd("fail to load view")
            return
        }
//        guard let view = bundle?.loadNibNamed("PromptCommonPopupView", owner: parent, options: nil)?[0] as? PromptCommonPopupView else {
//            printd("fail to load view")
//            return
//        }
        view.backgroundView = view
        view.dialogView = view.popupView
        view.titleLabel.text = title
        view.contentLabel.text = text
        view.contentLabel.textAlignment = textAlign
        view.confirmButton.setTitle(confirmText, for: .normal)
        view.confirmButton.layer.cornerRadius = 12
        view.confirmButton.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.confirmAction = confirmAction
        view.cancelButton.setTitle(cancelText, for: .normal)
        view.cancelButton.layer.cornerRadius = 12
        view.cancelButton.layer.maskedCorners = [.layerMinXMaxYCorner]
        view.cancelAction = cancelAction
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parent.topAnchor),
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            view.leftAnchor.constraint(equalTo: parent.leftAnchor),
            view.rightAnchor.constraint(equalTo: parent.rightAnchor),
        ])
//        view.snp.makeConstraints { (make) in
//            make.edges.equalTo(parent)
//        }
        
        view.show(animated: true)
    }
    
    class func createView(_ parent: UIView, title: String, attributeText: NSAttributedString = NSAttributedString(string: ""), textAlign: NSTextAlignment = .left, confirmText: String? = TAConstants.COMMON_CONFIRM_TITLE, confirmAction: (() -> Void)? = nil, cancelText: String? = TAConstants.COMMON_CANCEL_TITLE, cancelAction: (() -> Void)? = nil) {
        //guard let view = Bundle.main.loadNibNamed("PromptCommonPopupView", owner: parent)?[0] as?
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        guard let view = Bundle.module.loadNibNamed("PromptCommonPopupView", owner: parent, options: nil)?[0] as? PromptCommonPopupView else {
            printd("fail to load view")
            return
        }
//        guard let view = bundle?.loadNibNamed("PromptCommonPopupView", owner: parent, options: nil)?[0] as? PromptCommonPopupView else {
//            printd("fail to load view")
//            return
//        }
        
        view.backgroundView = view
        view.dialogView = view.popupView
        view.titleLabel.text = title
        view.contentLabel.attributedText = attributeText
        view.contentLabel.textAlignment = textAlign
        view.confirmButton.setTitle(confirmText, for: .normal)
        view.confirmButton.layer.cornerRadius = 12
        view.confirmButton.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.confirmAction = confirmAction
        view.cancelButton.setTitle(cancelText, for: .normal)
        view.cancelButton.layer.cornerRadius = 12
        view.cancelButton.layer.maskedCorners = [.layerMinXMaxYCorner]
        view.cancelAction = cancelAction
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parent.topAnchor),
            view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            view.leftAnchor.constraint(equalTo: parent.leftAnchor),
            view.rightAnchor.constraint(equalTo: parent.rightAnchor),
        ])
//        view.snp.makeConstraints { (make) in
//            make.edges.equalTo(parent)
//        }
        
        view.show(animated: true)
    }
    
    class func createView(_ parent: UIView, title: String, text: String = "", textColor: UIColor, textSize: CGFloat, textAlign: NSTextAlignment = .left, confirmText: String? = TAConstants.COMMON_CONFIRM_TITLE, confirmAction: (() -> Void)? = nil, cancelText: String? = TAConstants.COMMON_CANCEL_TITLE, cancelAction: (() -> Void)? = nil) {
            //guard let view = Bundle.main.loadNibNamed("PromptCommonPopupView", owner: parent)?[0] as?
            let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
            guard let view = Bundle.module.loadNibNamed("PromptCommonPopupView", owner: parent, options: nil)?[0] as? PromptCommonPopupView else {
                printd("fail to load view")
                return
            }
//            guard let view = bundle?.loadNibNamed("PromptCommonPopupView", owner: parent, options: nil)?[0] as? PromptCommonPopupView else {
//                printd("fail to load view")
//                return
//            }
            //view.backgroundView = view       //-> 2020210 memory leak problem update
            //view.dialogView = view.popupView //-> 2020210 memory leak problem update
            view.titleLabel.text = title
            view.contentLabel.text = text
            view.contentLabel.textColor = textColor
            view.contentLabel.font = view.contentLabel.font.withSize(textSize)
            view.contentLabel.textAlignment = textAlign
            view.confirmButton.setTitle(confirmText, for: .normal)
            view.confirmButton.layer.cornerRadius = 12
            view.confirmButton.layer.maskedCorners = [.layerMaxXMaxYCorner]
            view.confirmAction = confirmAction
            view.cancelButton.setTitle(cancelText, for: .normal)
            view.cancelButton.layer.cornerRadius = 12
            view.cancelButton.layer.maskedCorners = [.layerMinXMaxYCorner]
            view.cancelAction = cancelAction
            view.translatesAutoresizingMaskIntoConstraints = false
            parent.addSubview(view)
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: parent.topAnchor),
                view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
                view.leftAnchor.constraint(equalTo: parent.leftAnchor),
                view.rightAnchor.constraint(equalTo: parent.rightAnchor),
            ])
//            view.snp.makeConstraints { (make) in
//                make.edges.equalTo(parent)
//            }
            
            view.show(animated: true)
        }
    
    // MARK: - IBAction
    
    @IBAction func clickConfirm(_ sender: UIButton) {
        confirmAction?()
        dismiss(animated: true)
    }

    // MARK: - IBAction
    
    @IBAction func clickClose(_ sender: UIButton) {
        cancelAction?()
        dismiss(animated: true)
    }
}
