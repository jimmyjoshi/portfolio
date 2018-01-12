//
//  TeamDetailViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 08/09/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import MessageUI

class TeamDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {

    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lblTeamName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblEmailId: UILabel!
    @IBOutlet var lblWebsite: UILabel!
    
    @IBOutlet var tblTeamMember: UITableView!
    var arrTeamMember = NSMutableArray()
    var dictTeamDetails = NSDictionary()
    var dictTeamInfo = NSDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

       /* lblTeamName.text = "Accell"
        lblDescription.text = "Lorel Ipsum dolor view sit amet, consettinong adipiscing. Pellecitum so dales eros id maximum."
        
        lblAddress.text = "A 54, CenterMall, Near by Center Park, Mumbai 323001."
        lblEmailId.text = "info@accell.com"
        lblWebsite.text = "www.accell.com"
        // Do any additional setup after loading the view.
        
        setTemporaryData()*/
        self.getTeamDetails()
    }
    
    func getTeamDetails()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetTeamDetails
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let parameters: [String: Any] = ["teamId": "\(dictTeamDetails.value(forKey: "teamId")!)"]
        
        request(url, method: .post, parameters:parameters, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                        
                        if (dictemp.value(forKey: "error") != nil)
                        {
                            let msg = ((dictemp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            if let dictdata = dictemp.value(forKey: "data") as? NSDictionary
                            {
                                self.dictTeamInfo = (dictdata.value(forKey: "teamInfo") as? NSDictionary)!
                                
                                self.lblTeamName.text = self.dictTeamInfo["teamTitle"] as? String
                                self.lblDescription.text = self.dictTeamInfo["teamDescription"] as? String
                                
                                self.lblAddress.text = self.dictTeamInfo["teamAddress"] as? String
                                self.lblEmailId.text = self.dictTeamInfo["teamEmailId"] as? String
                                self.lblWebsite.text = self.dictTeamInfo["teamWebsite"] as? String

                                if let strimageLink = self.dictTeamInfo.value(forKey: "teamImage")
                                {
                                    let strURL : String = (strimageLink as AnyObject).replacingOccurrences(of: " ", with: "%20")
                                    let url2 = URL(string: strURL)
                                    if url2 != nil {
                                        self.imgVw.sd_setImage(with: url2, placeholderImage: nil)
                                    }
                                }

                                if let arrteamMembers = dictdata.value(forKey: "teamMembers") as? NSArray
                                {
                                    self.arrTeamMember = NSMutableArray(array: arrteamMembers)
                                }
                                self.tblTeamMember.reloadData()
                            }
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrTeamMember = NSMutableArray()
                self.tblTeamMember.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }


    func setTemporaryData() {
        arrTeamMember = NSMutableArray()
        arrTeamMember.add([kTeamMemberImageKey: "",kTeamMemberNameKey: "Benson Daniel",kTeamMemberPostKey: "Marketing Head",kTeamMemberContactNoKey: "+91 65821787"])
        arrTeamMember.add([kTeamMemberImageKey: "",kTeamMemberNameKey: "David Hall",kTeamMemberPostKey: "Sales Manager",kTeamMemberContactNoKey: "+91 3278698658"])
        arrTeamMember.add([kTeamMemberImageKey: "",kTeamMemberNameKey: "Elle Susan",kTeamMemberPostKey: "Sales Executive",kTeamMemberContactNoKey: "+91 435821787"])
        arrTeamMember.add([kTeamMemberImageKey: "",kTeamMemberNameKey: "Harry Carter",kTeamMemberPostKey: "Sales Executive",kTeamMemberContactNoKey: "+91 65821787"])
        tblTeamMember.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMenuClicked(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func btnSettingsClicked(sender: UIButton) {
        
    }
   
    
    //MARK:- UITableview Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTeamMember.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objTeamDetail  : TeamDetailViewController = storyTab.instantiateViewController(withIdentifier: "TeamDetailViewController") as! TeamDetailViewController
        self.navigationController?.pushViewController(objTeamDetail, animated: true)*/
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : teamMemberCell = tableView.dequeueReusableCell(withIdentifier: kTeamMemberCellIdentifier, for: indexPath) as! teamMemberCell
        let dictEntity : NSDictionary = arrTeamMember[indexPath.row] as! NSDictionary

        if let strimageLink = dictEntity.value(forKey: kTeamMemberImageKey)
        {
            let strURL : String = (strimageLink as AnyObject).replacingOccurrences(of: " ", with: "%20")
            let url2 = URL(string: strURL)
            if url2 != nil {
                cell.imgPic.sd_setImage(with: url2, placeholderImage: nil)
            }
        }

        if let name = dictEntity.value(forKey: kTeamMemberNameKey) {
            cell.lblName.text = "\(name)"
        }
        if let post = dictEntity.value(forKey: kTeamMemberPostKey)
        {
            cell.lblPost.text = "\(post)"
        }
        if let no = dictEntity.value(forKey: kTeamMemberContactNoKey)
        {
            cell.lblContactNo.text = "\(no)"
        }
        return cell
    }
    
    //MARK: Send email
    @IBAction func btnSendEmailAction(sender: AnyObject)
    {
        if MFMailComposeViewController.canSendMail()
        {
            let toRecipents = ["\(lblEmailId.text!)"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        }
        else
        {
            // show failure alert
            App_showAlert(withMessage: "Your device could not send e-mail.  Please check e-mail configuration and try again.", inView: self)
        }
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?)
    {
        switch result {
        case .cancelled:
            App_showAlert(withMessage: "Mail cancelled.", inView: self)
        case .saved:
            App_showAlert(withMessage: "Mail saved", inView: self)
        case .sent:
            App_showAlert(withMessage: "Mail sent", inView: self)
        case .failed:
            App_showAlert(withMessage: "Mail sent failure: \(String(describing: error?.localizedDescription))", inView: self)
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }

}

class teamMemberCell : UITableViewCell {
    @IBOutlet var imgPic: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPost: UILabel!
    @IBOutlet var lblContactNo: UILabel!
}
