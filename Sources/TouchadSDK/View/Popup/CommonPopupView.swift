//
//  CommonPopupView.swift
//  touchad
//
//  Created by shimtaewoo on 2020/09/09.
//  Copyright © 2020 developer. All rights reserved.
//
import UIKit
//import SnapKit

class CommonPopupView: UIView, Modal {
    var backgroundView: UIView = UIView()
    var dialogView: UIView = UIView()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    
    private var confirmAction: (() -> Void)?

    class func createView(_ parent: UIView, title: String, text: String = "", attributeText: NSAttributedString = NSAttributedString(string: ""), textAlign: NSTextAlignment = .left, confirmText: String? = TAConstants.COMMON_CONFIRM_TITLE, confirmAction: (() -> Void)? = nil) {
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        //guard let view = Bundle.main.loadNibNamed("CommonPopupView", owner: parent)?[0] as?
        guard let view = Bundle.module.loadNibNamed("CommonPopupView", owner: parent, options: nil)?[0] as? CommonPopupView else {
            printd("fail to load view")
            return
        }
        
        view.backgroundView = view
        view.dialogView = view.popupView
        view.titleLabel.text = title
        if attributeText.string == ""
        {
            view.contentLabel.text = text
        }
        else
        {
            view.contentLabel.attributedText = attributeText
        }
        view.contentLabel.textAlignment = textAlign
        view.confirmButton.setTitle(confirmText, for: .normal)
        view.confirmButton.layer.cornerRadius = 12
        view.confirmButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.confirmAction = confirmAction
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
    
    // MARK: - IBAction
    
    @IBAction func clickConfirm(_ sender: UIButton) {
        confirmAction?()
        dismiss(animated: true)
    }

    // MARK: - IBAction
    
    @IBAction func clickClose(_ sender: UIButton) {
        confirmAction?()
        dismiss(animated: true)
    }
}
