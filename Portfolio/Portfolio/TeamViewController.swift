//
//  EntitiesViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    @IBOutlet var tblTeam: UITableView!
    @IBOutlet var txtSearch: UITextField!
    var arrTeam = NSMutableArray()
    var arrOutSideTeam = NSMutableArray()
    var arrMainTeam = NSMutableArray()
    var arrMainOutSideTeam = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
        
//        self.setTemporaryData()
        self.getAllTeamMembers()
    }
    
    func getAllTeamMembers()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kgetTeamMembers
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        request(url, method: .get, parameters:nil, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
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
                            self.arrTeam = NSMutableArray()
                            self.arrOutSideTeam  = NSMutableArray()
                            self.arrMainTeam = NSMutableArray()
                            self.arrMainOutSideTeam = NSMutableArray()
                            self.tblTeam.reloadData()
                        }
                        else
                        {
                            if let dictTeams = dictemp.value(forKey: "data") as? NSDictionary
                            {
                                if let arrInsideTeam = dictTeams.value(forKey: "insideTeam") as? NSArray
                                {
                                    self.arrTeam = NSMutableArray(array: arrInsideTeam)
                                    self.arrMainTeam = NSMutableArray(array: arrInsideTeam)
                                }
                                if let arrOutsideTeam = dictTeams.value(forKey: "outsideTeam") as? NSArray
                                {
                                    self.arrOutSideTeam = NSMutableArray(array: arrOutsideTeam)
                                    self.arrMainOutSideTeam = NSMutableArray(array: arrOutsideTeam)
                                }
                            }
                            self.tblTeam.reloadData()
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrTeam = NSMutableArray()
                self.tblTeam.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tblTeam.estimatedRowHeight = 100.0
        self.tblTeam.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Tableview Delegate methods
    
    func setTemporaryData() {
        arrTeam.add([kTeamNameKey: "Accell",kTeamDescriptionKey: "Lorel ipsum sit amet conceptures",kTeamImageKey: "",kTeamStarKey: 5])
        arrTeam.add([kTeamNameKey: "Fund02",kTeamDescriptionKey: "Suspendisse cursus felis ut enim ",kTeamImageKey: "",kTeamStarKey: 4])
        arrTeam.add([kTeamNameKey: "Blume Ventures",kTeamDescriptionKey: "Maecenus sit amet elit nec turpis",kTeamImageKey: "",kTeamStarKey: 3])
        arrTeam.add([kTeamNameKey: "IDG Ventures",kTeamDescriptionKey: "Pelletensque lectus dui, suscipt",kTeamImageKey: "",kTeamStarKey: 2])
        arrTeam.add([kTeamNameKey: "Naspers",kTeamDescriptionKey: "Qui at digisom",kTeamImageKey: "",kTeamStarKey: 1])
        arrTeam.add([kTeamNameKey: "SteadView Capital",kTeamDescriptionKey: "Mascellea vitro chimpa",kTeamImageKey: "",kTeamStarKey: 0])
        self.tblTeam.reloadData()

    }
    
    //MARK:- Button Click Action
    @IBAction func btnMenuClicked(sender: UIButton) {
//        _ = self.navigationController?.popViewController(animated: true)
        SJSwiftSideMenuController.showLeftMenu()

    }
    
    @IBAction func btnSettingsClicked(sender: UIButton) {
        
    }
    
    @IBAction func btnSearchClicked(sender: UIButton)
    {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        self.searchdata()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        self.searchdata()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string.isEmpty)
        {
            self.arrTeam = self.arrMainTeam
            self.arrOutSideTeam = self.arrMainOutSideTeam
        }
        else
        {
            let resultPredicate : NSPredicate = NSPredicate(format: "Name contains[c] %@", string)
            self.arrTeam = self.arrMainTeam.filtered(using: resultPredicate) as! NSMutableArray
            self.arrOutSideTeam = self.arrMainOutSideTeam.filtered(using: resultPredicate) as! NSMutableArray

        }
        self.tblTeam.reloadData()
        return true
    }
    
    func searchdata()
    {
        if (self.txtSearch.text?.isEmpty)!
        {
            self.arrTeam = self.arrMainTeam
            self.arrOutSideTeam = self.arrMainOutSideTeam
        }
        else
        {
            let resultPredicate : NSPredicate = NSPredicate(format: "Name contains[c] %@", self.txtSearch.text!)
            self.arrTeam = self.arrMainTeam.filtered(using: resultPredicate) as! NSMutableArray
            self.arrOutSideTeam = self.arrMainOutSideTeam.filtered(using: resultPredicate) as! NSMutableArray
        }
        self.tblTeam.reloadData()
    }

    //MARK:- Table View Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if arrTeam.count > 0 && arrOutSideTeam.count > 0
        {
            return 2
        }
        else
        {
            return 1
        }
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        headerView.backgroundColor = UIColor.clear
        
        let imgbg = UIImageView(frame: CGRect(x: 10, y: 0, width: MainScreen.width-20, height: 40))
        imgbg.backgroundColor = UIColor.white
        imgbg.clipsToBounds = true
        imgbg.layer.cornerRadius = 5.0
        
        let lblText = UILabel(frame: CGRect(x: 25, y: 5, width: MainScreen.width-25, height: 30))
        if section == 0
        {
            lblText.text =  "Inside Team"
        }
        else
        {
            lblText.text = "Outside Team"
        }
        headerView.addSubview(imgbg)
        headerView.addSubview(lblText)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return arrTeam.count
        }
        else
        {
            return arrOutSideTeam.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 94
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objTeamDetail  : TeamDetailViewController = storyTab.instantiateViewController(withIdentifier: "TeamDetailViewController") as! TeamDetailViewController
        if indexPath.section == 0
        {
            objTeamDetail.dictTeamDetails = arrTeam[indexPath.row] as! NSDictionary
        }
        else if indexPath.section == 1
        {
            objTeamDetail.dictTeamDetails = arrOutSideTeam[indexPath.row] as! NSDictionary
        }
        self.navigationController?.pushViewController(objTeamDetail, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : teamCell = tableView.dequeueReusableCell(withIdentifier: kTeamCellIdentifier, for: indexPath) as! teamCell
        
        if indexPath.section == 0
        {
            let dictEntity : NSDictionary = arrTeam[indexPath.row] as! NSDictionary
            
            if let strimageLink = dictEntity.value(forKey: kImageKey)
            {
                let strURL : String = (strimageLink as AnyObject).replacingOccurrences(of: " ", with: "%20")
                let url2 = URL(string: strURL)
                if url2 != nil {
                    cell.imgPic.sd_setImage(with: url2, placeholderImage: nil)
                }
            }
            
            if let name = dictEntity.value(forKey: kCompanyNamKey)
            {
                cell.lblName.text = "\(name)"
            }
            
            if let description = dictEntity.value(forKey: kDescriptionKey)
            {
                cell.lblDescription.text = "\(description)"
            }
        }
        else if indexPath.section == 1
        {
            let dictEntity : NSDictionary = arrOutSideTeam[indexPath.row] as! NSDictionary
            
            if let strimageLink = dictEntity.value(forKey: kImageKey)
            {
                let strURL : String = (strimageLink as AnyObject).replacingOccurrences(of: " ", with: "%20")
                let url2 = URL(string: strURL)
                if url2 != nil {
                    cell.imgPic.sd_setImage(with: url2, placeholderImage: nil)
                }
            }
            
            if let name = dictEntity.value(forKey: kCompanyNamKey)
            {
                cell.lblName.text = "\(name)"
            }
            
            if let description = dictEntity.value(forKey: kDescriptionKey)
            {
                cell.lblDescription.text = "\(description)"
            }

        }
        
        return cell
    }
}

//MARK:- Cell for displaying entity
class teamCell : UITableViewCell {
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
}




