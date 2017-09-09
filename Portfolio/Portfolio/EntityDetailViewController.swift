//
//  EntityDetailViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 08/09/17.
//  Copyright © 2017 Niyati. All rights reserved.
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTemporaryValues()
        
        //htMainContentVw.constant = 313
    }

    func setTemporaryValues() {
        lblEntityName.text = "Entity 1"
        lblEntityDetail.text = "This is temporary fund that has been set to check the validity"
        
        lblInceptionDate.text = "15 May 17"
        lblFundSize.text = "$45,000"
        lblTotalInvested.text = "$32,300"
        lblAssetClass.text = "C"
        
        setCompanyData()
    }
    
    func setCompanyData() {
        var arrTempArray = NSMutableArray()
        
        arrTempArray.add([kEntityDetailCompanyNameKey: "Morgan Pvt",kEntityDetailCompanyAmountKey: "$45,000",kEntityDetailCompanyPerKey: "22%"])
        arrTempArray.add([kEntityDetailCompanyNameKey: "Reliance Capital Pvt",kEntityDetailCompanyAmountKey: "$30,000",kEntityDetailCompanyPerKey: "15%"])
        arrTempArray.add([kEntityDetailCompanyNameKey: "Morgan Chase",kEntityDetailCompanyAmountKey: "$85",kEntityDetailCompanyPerKey: "19%"])
        
        
        arrCompanyData = NSMutableArray()
        arrCompanyData.add([kEntityDetailCompanyTitleNameKey: "Real Estate","isSelected": "0",kEntityDetailCompanyArrKey: arrTempArray])
        arrCompanyData.add([kEntityDetailCompanyTitleNameKey: "Cooper","isSelected": "0",kEntityDetailCompanyArrKey: arrTempArray])
        arrCompanyData.add([kEntityDetailCompanyTitleNameKey: "Hedge Fund","isSelected": "0",kEntityDetailCompanyArrKey: arrTempArray])
        
        htCompanyTable.constant = 474.0//CGFloat(calculateHeaderRows())
        htMainContentVw.constant = 300.0
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
    
    @IBAction func btnSettingsClicked(sender: UIButton) {
        
    }
    func calculateHeaderRows() -> Int
    {
        let intHeader : Int = arrCompanyData.count
        var intRow : Int = 0
        
        for arr in arrCompanyData {
            let tmpArr : NSArray = (arr as! NSDictionary).value(forKey: "kEntityDetailCompanyArrKey") as! NSArray
            intRow = intRow + tmpArr.count
        }
        return ((intHeaderHt * intHeader) + (intRowHt * intRow))
    }
    //MARK:- Table View Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCompanyData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dict : NSDictionary = arrCompanyData[section] as! NSDictionary
        if let arr = dict.value(forKey: kEntityDetailCompanyArrKey){
            var tmpArray = arr as! NSMutableArray
            return tmpArray.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(intRowHt)//39
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : headerCell = tableView.dequeueReusableCell(withIdentifier: kEntityDetailHeaderCellIdentifier) as! headerCell
        let dict : NSDictionary = arrCompanyData[section] as! NSDictionary
        if let name = dict.value(forKey: kEntityDetailCompanyTitleNameKey){
            cell.lblTitle.text = "\(name)"
        }
        return cell.contentView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(intHeaderHt)//41
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : companyDetailCell = tableView.dequeueReusableCell(withIdentifier: kEntityDetailCompanyCellIdentifier, for: indexPath) as! companyDetailCell
        let dictMain : NSDictionary = arrCompanyData[indexPath.section] as! NSDictionary
        let dicCompany : NSDictionary = (dictMain.value(forKey: kEntityDetailCompanyArrKey) as! NSArray).object(at: indexPath.row) as! NSDictionary
        if let name = dicCompany.value(forKey: kEntityDetailCompanyNameKey) {
            cell.lblCompanyName.text = "\(name)"
        }
        if let amount = dicCompany.value(forKey: kEntityDetailCompanyAmountKey) {
            cell.lblMoneyInvested.text = "\(amount)"
        }
        if let percent = dicCompany.value(forKey: kEntityDetailCompanyPerKey) {
            cell.lblPercent.text = "\(percent)"
        }
        return cell
    }
}

class headerCell : UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnAdd: UIButton!
}

class companyDetailCell : UITableViewCell {
    @IBOutlet var lblCompanyName: UILabel!
    @IBOutlet var lblMoneyInvested: UILabel!
    @IBOutlet var lblPercent: UILabel!
}
