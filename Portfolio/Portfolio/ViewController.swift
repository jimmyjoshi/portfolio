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


}

