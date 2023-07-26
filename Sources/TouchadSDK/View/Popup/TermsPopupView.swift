//
//  TermsPopupView.swift
//  TouchadSDK
//
//  Created by 이윤표 on 2023/04/25.
//

import UIKit

class TermsPopupView: UIView, Modal {
    var backgroundView: UIView = UIView()
    var dialogView: UIView = UIView()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var termsFirstLabel: UILabel!
    @IBOutlet weak var termsSecondLabel: UILabel!
    @IBOutlet weak var termsThirdLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var moveToUrlAction: ((_ strUrl: String) -> Void)?
    private var confirmAction: (() -> Void)?
    private var cancelAction: (() -> Void)?
    
    static var termsFirstUrl: String = ""
    static var termsSecondUrl: String = ""
    static var termsThirdUrl: String = ""

    class func createView(_ parent: UIView, title: String, jsonStr: String, textAlign: NSTextAlignment = .left, confirmText: String? = TAConstants.COMMON_CONFIRM_TITLE, confirmAction: (() -> Void)? = nil, cancelText: String? = TAConstants.COMMON_CANCEL_TITLE, cancelAction: (() -> Void)? = nil, moveToUrlAction: ((_ strUrl: String) -> Void)?) {
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        guard let view = bundle?.loadNibNamed("TermsPopupView", owner: parent, options: nil)?[0] as? TermsPopupView else {
            printd("fail to load view")
            return
        }
        
        var dicData : Dictionary<String, Any> = [String : Any]()
        do
        {
            dicData = try JSONSerialization.jsonObject(with: Data(jsonStr.utf8), options: []) as! Dictionary<String, Any>
        }
        catch
        {
            printd(error.localizedDescription)
        }
        
        view.backgroundView = view
        view.dialogView = view.popupView
        view.titleLabel.text = title
        
        view.contentLabel.text = dicData["title"] as? String
        view.contentLabel.textAlignment = textAlign
        
        view.termsFirstLabel.text = dicData["term1"] as? String
        view.termsFirstLabel.textAlignment = textAlign
        termsFirstUrl = dicData["term1Url"] as? String ?? ""
        
        view.termsSecondLabel.text = dicData["term2"] as? String
        view.termsSecondLabel.textAlignment = textAlign
        termsSecondUrl = dicData["term2Url"] as? String ?? ""
        
        view.termsThirdLabel.text = dicData["term3"] as? String
        view.termsThirdLabel.textAlignment = textAlign
        termsThirdUrl = dicData["term3Url"] as? String ?? ""
        
        view.confirmButton.setTitle(confirmText, for: .normal)
        view.confirmAction = confirmAction
        view.cancelButton.setTitle(cancelText, for: .normal)
        view.cancelAction = cancelAction
        view.moveToUrlAction = moveToUrlAction
        parent.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(parent)
        }
        
        view.show(animated: true)
    }
    
    @IBAction func clickFirstTerms(_ sender: UIView) {
        moveToUrlAction?(TermsPopupView.termsFirstUrl)
    }
    
    @IBAction func clickSecondTerms(_ sender: UIView) {
        moveToUrlAction?(TermsPopupView.termsSecondUrl)
    }
    
    @IBAction func clickThirdTerms(_ sender: UIView) {
        moveToUrlAction?(TermsPopupView.termsThirdUrl)
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
