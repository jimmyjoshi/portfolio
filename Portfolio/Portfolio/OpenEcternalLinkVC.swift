//
//  OpenEcternalLinkVC.swift
//  Portfolio
//
//  Created by Yash on 06/01/18.
//  Copyright © 2018 Niyati. All rights reserved.
//

import UIKit

class OpenEcternalLinkVC: UIViewController {

    @IBOutlet weak var webView : UIWebView!
    var strURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL (string: strURL)
        let requestObj = NSURLRequest(url: url! as URL)
        webView.loadRequest(requestObj as URLRequest)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnMenuClicked(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

    func webViewDidStartLoad(webView : UIWebView)
    {
        showProgress(inView: self.view)
    }
    
    func webViewDidFinishLoad(webView : UIWebView)
    {
        hideProgress()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
