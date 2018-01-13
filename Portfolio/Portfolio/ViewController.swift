//
//  ViewController.swift
//  Portfolio
//
//  Created by Kevin on 29/08/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var btnRememberMe : UIButton!

    override func viewDidLoad()
    {
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        SJSwiftSideMenuController.hideLeftMenu()
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .NONE)
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
        if (self.txtUserName.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter username", inView: self)
        }
        else if (self.txtPassword.text?.isEmpty)!
        {
            App_showAlert(withMessage: "Please enter password", inView: self)
        }
        else
        {
            self.view .endEditing(true)
            self.callLoginAPI()
        }
        
       /* let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objForgotPasswordVC = storyTab.instantiateViewController(withIdentifier: "DashboardVC")
        self.navigationController?.pushViewController(objForgotPasswordVC, animated: true)*/
    }
    func callLoginAPI()
    {
        let url = kServerURL + kLogin
        let parameters: [String: Any] = ["email": self.txtUserName.text!, "password": self.txtPassword.text!]
        
        showProgress(inView: self.view)
        print("parameters:>\(parameters)")
        request(url, method: .post, parameters:parameters).responseJSON { (response:DataResponse<Any>) in
            
            print(response.result.debugDescription)
            
            hideProgress()
            switch(response.result)
            {
            case .success(_):
                if response.result.value != nil
                {
                    print(response.result.value!)
                    
                    if let json = response.result.value
                    {
                        let dictemp = json as! NSDictionary
                        print("dictemp :> \(dictemp)")
                        
                        if dictemp.count > 0
                        {
                            if let err  =  dictemp.value(forKey: kkeyError)
                            {
                                App_showAlert(withMessage: err as! String, inView: self)
                            }
                            else
                            {
                                appDelegate.arrLoginData = dictemp
                                let data = NSKeyedArchiver.archivedData(withRootObject: appDelegate.arrLoginData)
                                UserDefaults.standard.set(data, forKey: kkeyLoginData)
                                if(self.btnRememberMe.isSelected)
                                {
                                    UserDefaults.standard.set(true, forKey: kkeyisUserLogin)
                                }
                                else
                                {
                                    UserDefaults.standard.set(false, forKey: kkeyisUserLogin)
                                }
                                UserDefaults.standard.synchronize()
                                
                                let storyTab = UIStoryboard(name: "Main", bundle: nil)
                                let objForgotPasswordVC = storyTab.instantiateViewController(withIdentifier: "DashboardVC")
                                self.navigationController?.pushViewController(objForgotPasswordVC, animated: true)
                            }
                        }
                        else
                        {
                            App_showAlert(withMessage: dictemp[kkeyError]! as! String, inView: self)
                        }
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error!)
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
        
        /*request("\(kServerURL)login.php", method: .post, parameters:parameters).responseString{ response in
         debugPrint(response)
         }*/
    }
    

    @IBAction func btnRememberMeAction(_ sender: UIButton)
    {
        if(sender.isSelected == true)
        {
            sender.isSelected = false
        }
        else
        {
            sender.isSelected = true
        }
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
