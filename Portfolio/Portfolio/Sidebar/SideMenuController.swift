//
//  SideMenuController.swift
//  SJSwiftNavigationController
//
//  Created by Mac on 12/19/16.
//  Copyright © 2016 Sumit Jagdev. All rights reserved.
//

import UIKit

class SideMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var menuTableView : UITableView!
   
    var menuItems : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuTableView.estimatedRowHeight = 200.0
        self.menuTableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuTableView.allowsSelection = true
        menuTableView.isUserInteractionEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 9
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sidebar1", for: indexPath) as! Sidebar1
            cell.lblTitle.text = "Alex James"
            
            let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
            let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary

            if let strimageLink = final.value(forKey: "profilePic")
            {
                let strURL : String = (strimageLink as AnyObject).replacingOccurrences(of: " ", with: "%20")
                let url2 = URL(string: strURL)
                if url2 != nil {
                    cell.imgProfile.sd_setImage(with: url2, placeholderImage: nil)
                }
            }

            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Sidebar2
            cell.selectionStyle = .none

            switch indexPath.row
            {
                case 1:
                    cell.lblTitle.text = "Financial Summary"
                    cell.imgIcon.image = UIImage(named: "Whitedoller_icon")
                    break
                case 2:
                    cell.lblTitle.text = "Entities"
                    cell.imgIcon.image = UIImage(named: "entity_icon")
                    break
                case 3:
                    cell.lblTitle.text = "Teams"
                    cell.imgIcon.image = UIImage(named: "Whiteteam_icon")
                break

                case 4:
                    cell.lblTitle.text = "Companies"
                    cell.imgIcon.image = UIImage(named: "company_icon")
                    break
                case 5:
                    cell.lblTitle.text = "Contacts"
                    cell.imgIcon.image = UIImage(named: "contact_icon")
                    break
                case 6:
                    cell.lblTitle.text = "Documents"
                    cell.imgIcon.image = UIImage(named: "document_icon")
                    break
                case 7:
                    cell.lblTitle.text = "News"
                    cell.imgIcon.image = UIImage(named: "news_icon")
                    break
                case 8:
                    cell.lblTitle.text = "Logout"
                    cell.imgIcon.image = UIImage(named: "logout_icon")
                    break
                default:
                    break
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     /*   let destVC = UIViewController()
        destVC.view.backgroundColor = UIColor.randomColor()
       
        let monthName = menuItems.object(at: indexPath.row) as? String
         destVC.title = monthName*/
        
        SJSwiftSideMenuController.hideLeftMenu()

        switch indexPath.row
        {
            case 0:
                let storyTab = UIStoryboard(name: "Main", bundle: nil)
                let objFin : DashboardVC = storyTab.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
                SJSwiftSideMenuController.pushViewController(objFin, animated: true)
                break
            case 1:
                let storyTab = UIStoryboard(name: "Main", bundle: nil)
                let objFin : FinancialSummaryViewController = storyTab.instantiateViewController(withIdentifier: "FinancialSummaryViewController") as! FinancialSummaryViewController
                SJSwiftSideMenuController.pushViewController(objFin, animated: true)
                break
            case 2:
                let storyTab = UIStoryboard(name: "Main", bundle: nil)
                let objEntity  : EntitiesViewController = storyTab.instantiateViewController(withIdentifier: "EntitiesViewController") as! EntitiesViewController
                SJSwiftSideMenuController.pushViewController(objEntity, animated: true)
                break
            case 3:
                let storyTab = UIStoryboard(name: "Main", bundle: nil)
                let objTeam  : TeamViewController = storyTab.instantiateViewController(withIdentifier: "TeamViewController") as! TeamViewController
                SJSwiftSideMenuController.pushViewController(objTeam, animated: true)
                break
            case 4:
                let storyTab = UIStoryboard(name: "Main", bundle: nil)
                let objCompanies : CompanyViewController = storyTab.instantiateViewController(withIdentifier: "CompanyViewController") as! CompanyViewController
                SJSwiftSideMenuController.pushViewController(objCompanies, animated: true)
                break
            case 5:
                let storyTab = UIStoryboard(name: "Main", bundle: nil)
                let objContactsVC : ContactsViewController = storyTab.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
                SJSwiftSideMenuController.pushViewController(objContactsVC, animated: true)
                break
            case 6:
                let storyTab = UIStoryboard(name: "Main", bundle: nil)
                let objDocuments  : DocumentsViewController = storyTab.instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
                SJSwiftSideMenuController.pushViewController(objDocuments, animated: true)
                break
            case 7:
                let storyTab = UIStoryboard(name: "Main", bundle: nil)
                let objNewsVC : NewsViewController = storyTab.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
                SJSwiftSideMenuController.pushViewController(objNewsVC, animated: true)
                break
            case 8:
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let rootVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as UIViewController
                UserDefaults.standard.set(false, forKey: kkeyisUserLogin)
                UserDefaults.standard.synchronize()
                SJSwiftSideMenuController.pushViewController(rootVC, animated: true)
                break
            default:
                break
        }

        
        
      //  SJSwiftSideMenuController.pushViewController(destVC, animated: true)
        
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

class Sidebar1 : UITableViewCell
{
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgProfile :  UIImageView!
}

class Sidebar2 : UITableViewCell
{
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgIcon :  UIImageView!
}
