//
//  NewsViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tblCompany: UITableView!
    @IBOutlet var txtSearch: UITextField!
    
    var arrCompany = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTemporaryData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Tableview Delegate methods
    
    func setTemporaryData() {
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
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSettingsClicked(sender: UIButton) {
        
    }
    
    @IBAction func btnSearchClicked(sender: UIButton) {
        self.view.endEditing(true)
        print("Searching data")
        
    }
    
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCompany.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return 48
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mainCell  = UITableViewCell()
        
        if indexPath.row == 0 {
            let cell : companyHeaderCell = tableView.dequeueReusableCell(withIdentifier: kCompanyHeaderIdentifier, for: indexPath) as! companyHeaderCell
            mainCell = cell
        }
        else
        {
            let cell : companyCell = tableView.dequeueReusableCell(withIdentifier: kCompanyCellIdentifier, for: indexPath) as! companyCell
            let dictEntity : NSDictionary = arrCompany[indexPath.row-1] as! NSDictionary
            if let name = dictEntity.value(forKey: kCompanyNamKey) {
                cell.lblName.text = "\(name)"
            }
            if let amount = dictEntity.value(forKey: kCompanyAmountKey) {
                cell.lblAmount.text = "\(amount)"
            }
            if let percent = dictEntity.value(forKey: kCompanyPercentKey) {
                cell.lblPercent.text = "\(percent)"
            }
            
            if indexPath.row == arrCompany.count {
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
class companyCell : UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var imgSeperator: UIImageView!
}

class companyHeaderCell : UITableViewCell {
    @IBOutlet weak var btnName: UIButton!
    @IBOutlet weak var btnAmount: UIButton!
    @IBOutlet weak var btnPercent: UIButton!
}
