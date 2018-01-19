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
    var dictFundDetails = NSDictionary()
    var dictMain = NSDictionary()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        setTemporaryValues()
        self.getEntityDetails()
        
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
        let arrTempArray = NSMutableArray()
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEntityDetails()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetFundDetails
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let parameters: [String: Any] = ["fundId": "\(dictFundDetails.value(forKey: "entityId")!)"]
        
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
                            self.arrCompanyData = NSMutableArray()
                            let msg = ((dictemp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
//                            self.arrCompanyData = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                            if let dictdata = dictemp.value(forKey: "data") as? NSDictionary
                            {
                                
                                self.dictMain = dictdata
                                self.lblEntityName.text = dictdata.value(forKey: "fundTitle") as? String
                                self.lblEntityDetail.text = dictdata.value(forKey: "description") as? String
                                
                                self.lblInceptionDate.text = dictdata.value(forKey: "inceptionDate") as? String
                                self.lblFundSize.text = "$\(dictdata.value(forKey: "fundSize") as! NSNumber)"
                                self.lblTotalInvested.text = "$\(dictdata.value(forKey: "totalInvested") as! NSNumber)"
                                self.lblAssetClass.text = dictdata.value(forKey: "assetClass") as? String
                                
                                self.arrCompanyData = NSMutableArray()
                                if let dictcompanies = dictdata.value(forKey: "companies") as? NSDictionary
                                {
                                    print(dictcompanies.allKeys)
                                    let arrAllKeyData = dictcompanies.allKeys as NSArray
                                    for i in 0..<arrAllKeyData.count
                                    {
                                        let dicttemp = NSMutableDictionary()
                                        dicttemp.setValue(arrAllKeyData[i], forKey: kEntityDetailCompanyTitleNameKey)
                                        dicttemp.setValue("0", forKey: "isSelected")
                                        dicttemp.setValue(dictcompanies.value(forKey: arrAllKeyData[i] as! String), forKey: kEntityDetailCompanyArrKey)
                                        self.arrCompanyData.add(dicttemp)
                                    }
                                }
                            }
                        }
                        
                        self.htCompanyTable.constant = (CGFloat(self.arrCompanyData.count * 41))
                        self.htMainContentVw.constant = 350 + self.htCompanyTable.constant
                        self.tblCompany.reloadData()
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrCompanyData = NSMutableArray()
                self.htCompanyTable.constant = (CGFloat(self.arrCompanyData.count * 41))
                self.htMainContentVw.constant = 350 + self.htCompanyTable.constant
                self.tblCompany.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    //MARK:- Button Click Action
    @IBAction func btnMenuClicked(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSettingsClicked(sender: UIButton)
    {
        
    }
    
    @IBAction func btnGotoFundDetails(sender: UIButton)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objEntityDetail  : FundDetailVC = storyTab.instantiateViewController(withIdentifier: "FundDetailVC") as! FundDetailVC
        objEntityDetail.dictFundDetails = self.dictMain
        self.navigationController?.pushViewController(objEntityDetail, animated: true)
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
                let tmpArray = arr as! NSArray
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
        if let name = dict.value(forKey: kEntityDetailCompanyTitleNameKey)
        {
            cell.lblTitle.text = "\(name)"
        }
        
        if dict.value(forKey: "isSelected") as! String == "1"
        {
            cell.btnAdd.isSelected = true
        }
        else
        {
            cell.btnAdd.isSelected = false
        }
        
        cell.btnAdd.addTarget(self, action: #selector(self.ExpandCell(_:)), for: .touchUpInside)
        cell.btnAdd.tag = section

        return cell.contentView
    }
    
    @IBAction func ExpandCell(_ sender: UIButton)
    {
        let dict  = arrCompanyData[sender.tag] as! NSMutableDictionary
        if dict.value(forKey: "isSelected") as! String == "1"
        {
            dict.setValue("0", forKey: "isSelected")
        }
        else
        {
            dict.setValue("1", forKey: "isSelected")
        }
        
        let resultPredicate = NSPredicate(format: "isSelected contains[c] %@", "1")
        let temparr = self.arrCompanyData.filtered(using: resultPredicate) as NSArray
        
        self.htCompanyTable.constant = (CGFloat(self.arrCompanyData.count * 41))

        for i in 0..<temparr.count
        {
            let dictMain : NSMutableDictionary = temparr[i] as! NSMutableDictionary
            let arrCompany  = (dictMain.value(forKey: kEntityDetailCompanyArrKey) as! NSArray)
            htCompanyTable.constant = self.htCompanyTable.constant + (CGFloat(arrCompany.count * 41))
        }
        
        htMainContentVw.constant = 350 + htCompanyTable.constant
        arrCompanyData.replaceObject(at: sender.tag, with: dict)
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
        if let amount = dicCompany.value(forKey: kamount)
        {
            cell.lblMoneyInvested.text = "\(amount)"
        }
        if let percent = dicCompany.value(forKey: kCompanyPercentKey)
        {
            cell.lblPercent.text = "\(percent)%"
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
