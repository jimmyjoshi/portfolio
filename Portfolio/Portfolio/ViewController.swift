//
//  ViewController.swift
//  Portfolio
//
//  Created by Yash on 29/08/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    override func viewDidLoad()
    {
        self.navigationController?.navigationBar.isHidden = true
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SJSwiftSideMenuController.hideLeftMenu()
        SJSwiftSideMenuController.enableDimBackground = true
    }
    override var prefersStatusBarHidden : Bool
    {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSIGNINAction(_ sender: Any)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objForgotPasswordVC = storyTab.instantiateViewController(withIdentifier: "DashboardVC")
        self.navigationController?.pushViewController(objForgotPasswordVC, animated: true)
    }
    
    @IBAction func btnforgotPWDAction(_ sender: Any)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objForgotPasswordVC = storyTab.instantiateViewController(withIdentifier: "ForgotPasswordVC")
        self.navigationController?.pushViewController(objForgotPasswordVC, animated: true)
    }
}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
