//
//  PopupViewController.swift
//  Mnemonic
//
//  Created by Thomas Martin on 28/07/2022.
//

import UIKit

class PopupViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var codeTxt: UILabel!
    @IBOutlet var copyBtn: UIButton!
    
    var passedData = String()
    var parentVC = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTxt.text = passedData
        backgroundView.layer.cornerRadius = 15
        copyBtn.backgroundColor = UIColor(named: "customBlue")
        copyBtn.setTitleColor(UIColor.white, for: .normal)
        copyBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func copyPress(_ sender: Any) {
        UIPasteboard.general.string = passedData
        parentVC.toast(message: "Copied")
        self.dismiss(animated: true)
    }
    
}
