//
//  DashboardVC.swift
//  Portfolio
//
//  Created by Yash on 30/08/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnEntitiesClicked(sender: UIButton)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objEntity  : EntitiesViewController = storyTab.instantiateViewController(withIdentifier: "EntitiesViewController") as! EntitiesViewController
        self.navigationController?.pushViewController(objEntity, animated: true)
    }

    @IBAction func btnTeamClicked(sender: UIButton) {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objTeam  : TeamViewController = storyTab.instantiateViewController(withIdentifier: "TeamViewController") as! TeamViewController
        self.navigationController?.pushViewController(objTeam, animated: true)
    }
    
    @IBAction func btnNewsClicked(sender: UIButton) {
        
    }
    
    @IBAction func btnCompaniesClicked(sender: UIButton) {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objNewsVC : NewsViewController = storyTab.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        objNewsVC.intType = 0
        self.navigationController?.pushViewController(objNewsVC, animated: true)
    }
    
    @IBAction func btnDocumentsClicked(sender: UIButton) {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objEntity  : DocumentsViewController = storyTab.instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
        self.navigationController?.pushViewController(objEntity, animated: true)
    }
    
    @IBAction func btnContactsClicked(sender: UIButton) {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objNewsVC : ContactsViewController = storyTab.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
        self.navigationController?.pushViewController(objNewsVC, animated: true)
    }
}
