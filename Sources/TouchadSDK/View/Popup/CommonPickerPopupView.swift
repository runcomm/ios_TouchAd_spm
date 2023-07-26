//
//  CommonPickerPopupView.swift
//  touchad
//
//  Created by shimtaewoo on 2020/09/04.
//  Copyright © 2020 developer. All rights reserved.
//
import UIKit
//import SnapKit

class CommonPickerPopupView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    
    var list: [String]?
    var selectIndex: Int?
    var confirmAction: ((Int) -> Void)?
    var cancelAction: (() -> Void)?
    var addAction: (() -> Void)?
    
    class func createView(_ parent: UIView, list: [String], selectIndex: Int? = 0, addAction: (() -> Void)? = nil, confirmAction: ((Int) -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        //guard let view = Bundle.main.loadNibNamed("CommonPickerPopupView", owner: parent)?[0] as?
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        guard let view = bundle?.loadNibNamed("CommonPickerPopupView", owner: parent, options: nil)?[0] as?        CommonPickerPopupView else {
            printd("fail to load view")
            return
        }
        
        if let addAction = addAction {
            view.addAction = addAction
            view.addButton.isHidden = false
        } else {
            view.addButton.isHidden = true
        }
        
        view.list = list
        view.selectIndex = selectIndex
        view.confirmAction = confirmAction
        view.cancelAction = cancelAction
        view.pickerView.selectRow(selectIndex ?? 0, inComponent: 0, animated: false)
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
        
        view.popupView.frame.origin.y = view.frame.size.height
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,  animations: {
            view.popupView.frame.origin.y = view.frame.size.height - view.popupView.frame.size.height
        })
    }
    
    class func createView(_ parent: UIView, list: [String], selectIndex: Int? = 0, confirmAction: ((Int) -> Void)? = nil) {
        //guard let view = Bundle.main.loadNibNamed("CommonPickerPopupView", owner: parent)?[0] as?
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        guard let view = bundle?.loadNibNamed("CommonPickerPopupView", owner: parent, options: nil)?[0] as? CommonPickerPopupView else {
            printd("fail to load view")
            return
        }
        
        view.addButton.isHidden = true
        view.list = list
        view.selectIndex = selectIndex
        view.confirmAction = confirmAction
        view.pickerView.selectRow(selectIndex ?? 0, inComponent: 0, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(view)
        view.topAnchor.constraint(equalTo: parent.topAnchor)
        view.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        view.leftAnchor.constraint(equalTo: parent.leftAnchor)
        view.rightAnchor.constraint(equalTo: parent.rightAnchor)
//        view.snp.makeConstraints { (make) in
//            make.edges.equalTo(parent)
//        }
        
        view.popupView.frame.origin.y = view.frame.size.height
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,  animations: {
            view.popupView.frame.origin.y = view.frame.size.height - view.popupView.frame.size.height
        })
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let list = list {
            return list.count
        }
        
        return 0
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let list = list {
            return list[row]
        }
        
        return nil
    }
    
    // MARK: - IBAction
    
    @IBAction func clickConfirm(_ sender: UIButton) {
        dismiss()
        confirmAction?(pickerView.selectedRow(inComponent: 0))
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        cancelAction?()
        dismiss()
    }
    
    @IBAction func clickAdd(_ sender: UIButton) {
        addAction?()
        dismiss()
    }

    private func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut,  animations: {
            self.popupView.frame.origin.y = self.frame.size.height
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
