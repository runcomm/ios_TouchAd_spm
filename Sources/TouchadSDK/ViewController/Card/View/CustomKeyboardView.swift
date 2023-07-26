//
//  CustomKeyboard.swift
//  touchad
//
//  Created by shimtaewoo on 2020/08/26.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

// The view controller will adopt this protocol (delegate)
// and thus must contain the keyWasTapped method
protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
    func nextStageTapped()
    func deleteWasTapped()
}

class CustomKeyboardView: UIView {
    // This variable will be set as the view controller so that
    // the keyboard can send messages to the view controller.
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    
    weak var delegate: KeyboardDelegate?
    // MARK:- keyboard initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }

    func initializeSubviews() {
        
        let bundle = Bundle(identifier: TAConstants.SDK_BUNDLE_IDENTIFIER)
        let view = bundle?.loadNibNamed("CustomKeyboardView", owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        shuffleKeyboard()
    
    }
    
    func shuffleKeyboard()
    {
        var array = ["0","1","2","3","4","5","6","7","8","9"]
        array.shuffle()
        self.button0.setTitle(array[0], for:.normal)
        self.button1.setTitle(array[1], for:.normal)
        self.button2.setTitle(array[2], for:.normal)
        self.button3.setTitle(array[3], for:.normal)
        self.button4.setTitle(array[4], for:.normal)
        self.button5.setTitle(array[5], for:.normal)
        self.button6.setTitle(array[6], for:.normal)
        self.button7.setTitle(array[7], for:.normal)
        self.button8.setTitle(array[8], for:.normal)
        self.button9.setTitle(array[9], for:.normal)
    }
    
    // MARK:- Button actions from .xib file

    @IBAction func keyTapped(sender: UIButton) {
        // When a button is tapped, send that information to the
        // delegate (ie, the view controller)
     
        self.delegate?.keyWasTapped(character: sender.titleLabel!.text!) // could alternatively send a tag value
    }
    @IBAction func nextTapped(sender: UIButton) {
        // When a button is tapped, send that information to the
        // delegate (ie, the view controller)
        self.delegate?.nextStageTapped() // could alternatively send a tag value
    }
    @IBAction func deleteTapped(sender: UIButton) {
        // When a button is tapped, send that information to the
        // delegate (ie, the view controller)
     
        self.delegate?.deleteWasTapped() // could alternatively send a tag value
    }
}
