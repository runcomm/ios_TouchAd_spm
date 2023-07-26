//
//  CommonPopupView.swift
//  touchad
//
//  Created by shimtaewoo on 2021/05/27.
//  Copyright © 2021 developer. All rights reserved.
//
import UIKit
//import SnapKit

class DalCoinPopupView: UIView, Modal {
    var backgroundView: UIView = UIView()
    var dialogView: UIView = UIView()

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
  
    class func createView(_ parent: UIView, attributeText: NSAttributedString = NSAttributedString(string: ""), textAlign: NSTextAlignment = .left) {
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        //guard let view = Bundle.main.loadNibNamed("CommonPopupView", owner: parent)?[0] as?
        guard let view = bundle?.loadNibNamed("DalCoinPopupView", owner: parent, options: nil)?[0] as? DalCoinPopupView else {
            printd("fail to load view")
            return
        }
        
        view.backgroundView = view
        view.dialogView = view.popupView
        view.contentLabel.attributedText = attributeText
        
        view.contentLabel.textAlignment = textAlign
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
        
        view.show(animated: true, dialogViewAlpha: 0.8)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
        
            view.dismiss(animated: true)
    
        }
        
    }

}
