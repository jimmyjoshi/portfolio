//
//  EntityDetailViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 08/09/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class EntityDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var lblEntityName: UILabel!
    @IBOutlet var lblEntityDetail: UILabel!
    
    @IBOutlet var lblInceptionDate: UILabel!
    @IBOutlet var lblFundSize: UILabel!
    @IBOutlet var lblTotalInvested: UILabel!
    @IBOutlet var lblAssetClass: UILabel!
    
    
    @IBOutlet var htMainContentVw: NSLayoutConstraint!
    @IBOutlet var htCompanyTable: NSLayoutConstraint!
    
    @IBOutlet var tblCompany: UITableView!
    
    var intHeaderHt : Int = 41
    var intRowHt : Int = 39
    
    var arrCompanyData = NSMutableArray()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTemporaryValues()
        
        //htMainContentVw.constant = 313
    }

    func setTemporaryValues()
    {
        lblEntityName.text = "Entity 1"
        lblEntityDetail.text = "This is temporary fund that has been set to check the validity"
        
        lblInceptionDate.text = "15 May 17"
        lblFundSize.text = "$45,000"
        lblTotalInvested.text = "$32,300"
        lblAssetClass.text = "C"
        
        setCompanyData()
    }
    
    func setCompanyData()
    {
        var arrTempArray = NSMutableArray()
        arrTempArray.add([kEntityDetailCompanyNameKey: "Morgan Pvt",kEntityDetailCompanyAmountKey: "$45,000",kEntityDetailCompanyPerKey: "22%"])
        arrTempArray.add([kEntityDetailCompanyNameKey: "Reliance Capital Pvt",kEntityDetailCompanyAmountKey: "$30,000",kEntityDetailCompanyPerKey: "15%"])
        arrTempArray.add([kEntityDetailCompanyNameKey: "Morgan Chase",kEntityDetailCompanyAmountKey: "$85",kEntityDetailCompanyPerKey: "19%"])
        
        arrCompanyData = NSMutableArray()
        var dicttemp = NSMutableDictionary()
        dicttemp.setValue("Real Estate", forKey: kEntityDetailCompanyTitleNameKey)
        dicttemp.setValue("0", forKey: "isSelected")
        dicttemp.setValue(arrTempArray, forKey: kEntityDetailCompanyArrKey)
        arrCompanyData.add(dicttemp)
        
        dicttemp = NSMutableDictionary()
        dicttemp.setValue("Cooper", forKey: kEntityDetailCompanyTitleNameKey)
        dicttemp.setValue("0", forKey: "isSelected")
        dicttemp.setValue(arrTempArray, forKey: kEntityDetailCompanyArrKey)
        arrCompanyData.add(dicttemp)
        
        dicttemp = NSMutableDictionary()
        dicttemp.setValue("Hedge Fund", forKey: kEntityDetailCompanyTitleNameKey)
        dicttemp.setValue("0", forKey: "isSelected")
        dicttemp.setValue(arrTempArray, forKey: kEntityDetailCompanyArrKey)
        arrCompanyData.add(dicttemp)
        
        htCompanyTable.constant = (CGFloat(arrCompanyData.count * 41))
        htMainContentVw.constant = 350 + htCompanyTable.constant
        tblCompany.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- Button Click Action
    @IBAction func btnMenuClicked(sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSettingsClicked(sender: UIButton)
    {
        
    }
    //MARK:- Table View Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCompanyData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dict : NSMutableDictionary = arrCompanyData[section] as! NSMutableDictionary
        if dict["isSelected"] as! String == "1"
        {
            if let arr = dict.value(forKey: kEntityDetailCompanyArrKey)
            {
                let tmpArray = arr as! NSMutableArray
                return tmpArray.count
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat(intRowHt)//39
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell : headerCell = tableView.dequeueReusableCell(withIdentifier: kEntityDetailHeaderCellIdentifier) as! headerCell
        let dict : NSMutableDictionary = arrCompanyData[section] as! NSMutableDictionary
        if let name = dict.value(forKey: kEntityDetailCompanyTitleNameKey){
            cell.lblTitle.text = "\(name)"
        }
        
        cell.btnAdd.addTarget(self, action: #selector(self.ExpandCell(_:)), for: .touchUpInside)
        cell.btnAdd.tag = section

        return cell.contentView
    }
    
    @IBAction func ExpandCell(_ sender: UIButton)
    {
        let dict  = arrCompanyData[sender.tag] as! NSMutableDictionary
        dict.setValue("1", forKey: "isSelected")
        arrCompanyData.replaceObject(at: sender.tag, with: dict)
        
        let resultPredicate = NSPredicate(format: "isSelected contains[c] %@", "1")
        let temparr = self.arrCompanyData.filtered(using: resultPredicate) as NSArray
        
        htCompanyTable.constant = (CGFloat(arrCompanyData.count * 41)) + (CGFloat((temparr.count * 3) * 41))
        htMainContentVw.constant = 350 + htCompanyTable.constant
        
        tblCompany.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return CGFloat(intHeaderHt)//41
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : companyDetailCell = tableView.dequeueReusableCell(withIdentifier: kEntityDetailCompanyCellIdentifier, for: indexPath) as! companyDetailCell
        let dictMain : NSMutableDictionary = arrCompanyData[indexPath.section] as! NSMutableDictionary
        let dicCompany : NSDictionary = (dictMain.value(forKey: kEntityDetailCompanyArrKey) as! NSArray).object(at: indexPath.row) as! NSDictionary
        if let name = dicCompany.value(forKey: kEntityDetailCompanyNameKey)
        {
            cell.lblCompanyName.text = "\(name)"
        }
        if let amount = dicCompany.value(forKey: kEntityDetailCompanyAmountKey)
        {
            cell.lblMoneyInvested.text = "\(amount)"
        }
        if let percent = dicCompany.value(forKey: kEntityDetailCompanyPerKey)
        {
            cell.lblPercent.text = "\(percent)"
        }
        return cell
    }
}

class headerCell : UITableViewCell
{
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnAdd: UIButton!
}

class companyDetailCell : UITableViewCell
{
    @IBOutlet var lblCompanyName: UILabel!
    @IBOutlet var lblMoneyInvested: UILabel!
    @IBOutlet var lblPercent: UILabel!
}
