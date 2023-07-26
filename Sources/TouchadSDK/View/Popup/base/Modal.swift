//
//  Modal.swift
//  touchad
//
//  Created by shimtaewoo on 2020/08/25.
//  Copyright © 2020 developer. All rights reserved.
//

import Foundation

import UIKit

protocol Modal {
    func show(animated:Bool, dialogViewAlpha:CGFloat)
    func dismiss(animated:Bool)
    var backgroundView:UIView {get}
    var dialogView:UIView {get set}
}

extension Modal where Self:UIView {
    func show(animated:Bool , dialogViewAlpha:CGFloat = 1.0){
        if animated {
            self.backgroundView.alpha = 0

            dialogView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            dialogView.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [],  animations: {
                self.dialogView.transform = .identity
                self.dialogView.alpha = dialogViewAlpha
                self.backgroundView.alpha = 1
            }, completion: { _ in
                
            })
        }else{
            self.backgroundView.alpha = 1
        }
    }
    
    func dismiss(animated:Bool){
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { _ in
                
            })
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [],  animations: {
                self.dialogView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.dialogView.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }else{
            self.removeFromSuperview()
        }
        
    }
}
