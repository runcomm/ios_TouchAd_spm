//
//  ErrorViewController.swift
//  TouchadSDK
//
//  Created by shimtaewoo on 2021/04/27.
//

import UIKit
import AVFoundation

class ErrorViewController: BaseViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var beforeButton: UIButton!
    
    public var errorCode: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beforeButton.applyGradient(with: [
            UIColor.rgb(140,39,211),
            UIColor.rgb(90,42,212)
        ], gradient: .horizontal)
        
        errorLabel.text = "에러코드 " + errorCode!
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
        if (self.navigationController != nil)
        {
            let vcs: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            if vcs.count >= 3 , let vc = vcs[vcs.count - 3] as? UIViewController
            {
                self.navigationController!.popToViewController(vc, animated: true)
            }
            //else
            //{
            //    self.navigationController!.dismiss(animated: true, completion: nil)
            //}
        }
        
    
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        
        if (self.navigationController != nil)
        {
            let vcs: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            if vcs.count >= 2 , let vc = vcs[vcs.count - 2] as? BaseViewController
            {
                vc.reloadWebView()
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
