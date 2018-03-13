//
//  NewsViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate
{
    @IBOutlet var tblCompany: UITableView!
    @IBOutlet var txtSearch: UITextField!
    var arrCompany = NSMutableArray()
    var strTitleofCash = String()
    var iTotoalCash = NSNumber()
    var arrMainCompany = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
        self.getUserCompanies()
    }
    
    func getUserCompanies()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetUserCompanies
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
                            self.arrCompany = NSMutableArray()
                             self.arrMainCompany = NSMutableArray()
                            let msg = ((dictemp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
//                            self.arrCompany = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                            if let dictdata = dictemp.value(forKey: "data") as? NSDictionary
                            {
                                if let arrcompanies = dictdata.value(forKey: "companies") as? NSArray
                                {
                                    self.arrCompany = NSMutableArray(array: arrcompanies)
                                    self.arrMainCompany = NSMutableArray(array: arrcompanies)
                                }
                                self.strTitleofCash = dictdata.value(forKey: "label") as! String
                                self.iTotoalCash = dictdata.value(forKey: "totalCash") as! NSNumber
                            }
                            self.tblCompany.reloadData()
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrCompany = NSMutableArray()
                self.arrMainCompany = NSMutableArray()
                self.tblCompany.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
//        setTemporaryData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Tableview Delegate methods
    
    func setTemporaryData()
    {
        arrCompany = NSMutableArray()
        arrCompany.add([kCompanyNamKey: "Avital",kCompanyAmountKey: "5000",kCompanyPercentKey: "10%"])
        arrCompany.add([kCompanyNamKey: "Aviva",kCompanyAmountKey: "10000",kCompanyPercentKey: "15%"])
        arrCompany.add([kCompanyNamKey: "Barscan",kCompanyAmountKey: "15000",kCompanyPercentKey: "10%"])
        arrCompany.add([kCompanyNamKey: "Bajaj Alliance",kCompanyAmountKey: "25000",kCompanyPercentKey: "28%"])
        arrCompany.add([kCompanyNamKey: "Birla Sun Life Insurance",kCompanyAmountKey: "25000",kCompanyPercentKey: "30%"])
        arrCompany.add([kCompanyNamKey: "DSPDR",kCompanyAmountKey: "10000",kCompanyPercentKey: "32%"])
        arrCompany.add([kCompanyNamKey: "Franklin India",kCompanyAmountKey: "25000",kCompanyPercentKey: "34%"])
        arrCompany.add([kCompanyNamKey: "Mira Asset India",kCompanyAmountKey: "32000",kCompanyPercentKey: "38%"])
        arrCompany.add([kCompanyNamKey: "SBI BlueChip",kCompanyAmountKey: "10000",kCompanyPercentKey: "42%"])
        arrCompany.add([kCompanyNamKey: "Kotak Select Focus",kCompanyAmountKey: "10000",kCompanyPercentKey: "45%"])
        
        
        tblCompany.reloadData()
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
        print("Searching data")
        txtSearch.resignFirstResponder()
        self.searchdata()
    }
    //MARK: TextField Delegate Methods
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (string.isEmpty)
        {
            self.arrCompany = self.arrMainCompany
        }
        else
        {
            let resultPredicate : NSPredicate = NSPredicate(format: "title contains[c] %@", string)
            self.arrCompany = self.arrMainCompany.filtered(using: resultPredicate) as! NSMutableArray
        }
        self.tblCompany.reloadData()
        return true
    }
    
    func searchdata()
    {
        if (self.txtSearch.text?.isEmpty)!
        {
            self.arrCompany = self.arrMainCompany
        }
        else
        {
            let resultPredicate : NSPredicate = NSPredicate(format: "title contains[c] %@", self.txtSearch.text!)
            self.arrCompany = self.arrMainCompany.filtered(using: resultPredicate) as! NSMutableArray
        }
        self.tblCompany.reloadData()
    }
    
    @IBAction func sortArrayValues(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: false)
            let sortedResults = arrCompany.sortedArray(using: [descriptor])
            self.arrCompany = NSMutableArray(array: (sortedResults as AnyObject) as! NSArray)
        }
        else if sender.tag == 2
        {
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "amount", ascending: false)
            let sortedResults = arrCompany.sortedArray(using: [descriptor])
            self.arrCompany = NSMutableArray(array: (sortedResults as AnyObject) as! NSArray)
        }
        else
        {
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "percentage", ascending: false)
            let sortedResults = arrCompany.sortedArray(using: [descriptor])
            self.arrCompany = NSMutableArray(array: (sortedResults as AnyObject) as! NSArray)
        }
        tblCompany.reloadData()
    }
    //MARK:- tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrCompany.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 50
        }
        return 48
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0
        {
            
        }
        else
        {
            let storyTab = UIStoryboard(name: "Main", bundle: nil)
            let objEntityDetail  : FundDetailVC = storyTab.instantiateViewController(withIdentifier: "FundDetailVC") as! FundDetailVC
            objEntityDetail.dictFundDetails = arrCompany[indexPath.row-1] as! NSDictionary
            self.navigationController?.pushViewController(objEntityDetail, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var mainCell  = UITableViewCell()
        
        if indexPath.row == 0
        {
            let cell : companyHeaderCell = tableView.dequeueReusableCell(withIdentifier: kCompanyHeaderIdentifier, for: indexPath) as! companyHeaderCell
            
            cell.btnName.addTarget(self, action: #selector(self.sortArrayValues(_:)), for: .touchUpInside)
            cell.btnName.tag = 1
            cell.btnAmount.addTarget(self, action: #selector(self.sortArrayValues(_:)), for: .touchUpInside)
            cell.btnAmount.tag = 2
            cell.btnPercent.addTarget(self, action: #selector(self.sortArrayValues(_:)), for: .touchUpInside)
            cell.btnPercent.tag = 3
            
            mainCell = cell
        }
        else
        {
            let cell : companyCell = tableView.dequeueReusableCell(withIdentifier: kCompanyCellIdentifier, for: indexPath) as! companyCell
            let dictEntity : NSDictionary = arrCompany[indexPath.row-1] as! NSDictionary
            
            if let name = dictEntity.value(forKey: ktitlekey)
            {
                cell.lblName.text = "\(name)"
            }
            
            if let amount = dictEntity.value(forKey: kamount)
            {
                cell.lblAmount.text = "$\(amount)"
            }
            
            if let percent = dictEntity.value(forKey: kCompanyPercentKey)
            {
                cell.lblPercent.text = "\(percent)%"
            }
            
            if indexPath.row == arrCompany.count
            {
                cell.imgSeperator.isHidden = true
            }
            else
            {
                cell.imgSeperator.isHidden = false
            }
            
            mainCell = cell
        }
        return mainCell
    }
}

class companyCell : UITableViewCell
{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var imgSeperator: UIImageView!
}

class companyHeaderCell : UITableViewCell
{
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var btnAmount: UIButton!
    @IBOutlet weak var btnPercent: UIButton!
}

