//
//  TeamDetailViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 08/09/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class TeamDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lblTeamName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblEmailId: UILabel!
    @IBOutlet var lblWebsite: UILabel!
    
    @IBOutlet var tblTeamMember: UITableView!
    var arrTeamMember = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTeamName.text = "Accell"
        lblDescription.text = "Lorel Ipsum dolor view sit amet, consettinong adipiscing. Pellecitum so dales eros id maximum."
        
        lblAddress.text = "A 54, CenterMall, Near by Center Park, Mumbai 323001."
        lblEmailId.text = "info@accell.com"
        lblWebsite.text = "www.accell.com"
        // Do any additional setup after loading the view.
        
        setTemporaryData()
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
        
        if let img = dictEntity.value(forKey: kTeamMemberImageKey) {
           
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
}

class teamMemberCell : UITableViewCell {
    @IBOutlet var imgPic: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPost: UILabel!
    @IBOutlet var lblContactNo: UILabel!
}
