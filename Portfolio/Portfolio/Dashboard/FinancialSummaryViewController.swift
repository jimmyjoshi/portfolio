//
//  FinancialSummaryViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 10/09/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class FinancialSummaryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblFinance: UITableView!
    var arrFinancialData = NSMutableArray()
    
    
    var isMore : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        
        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)

        
        self.tblFinance.estimatedRowHeight = 200.0
        self.tblFinance.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
        setTemporaryData()
    }

    func setTemporaryData() {
        
        var arrCash = NSMutableArray()
        arrCash.add([kFinancialCompanyNameKey: "Total Cash",kFinancialCompanyAmountKey: "$57,000"])
        arrCash.add([kFinancialCompanyNameKey: "Aviva Insurance",kFinancialCompanyAmountKey: "$25,000"])
        arrCash.add([kFinancialCompanyNameKey: "Shri Ram Group",kFinancialCompanyAmountKey: "$17,000"])
        arrCash.add([kFinancialCompanyNameKey: "Tata Group",kFinancialCompanyAmountKey: "$15,000"])
        
        var arrStatement = NSMutableArray()
        arrStatement.add([kFinancialCompanyNameKey: "Lorel Ipsum sit ament 2016",kFinancialCompanyDescKey: "C'est une nouvelle description qui a été entrée à chek"])
        arrStatement.add([kFinancialCompanyNameKey: "Suspendize poletin sed",kFinancialCompanyDescKey: "C'est une nouvelle description qui a été entrée à chek"])
        arrStatement.add([kFinancialCompanyNameKey: "Suspendize poletin sed",kFinancialCompanyDescKey: "C'est une nouvelle description qui a été entrée à chek"])
        
        var arrTaxDocument = NSMutableArray()
        arrTaxDocument.add([kFinancialCompanyNameKey: "Lorel Ipsum sit ament 2016"])
        arrTaxDocument.add([kFinancialCompanyNameKey: "Suspendize poletin sed"])
        
        arrFinancialData = NSMutableArray()
        arrFinancialData.add([kHeaderTitleKey: "Cash Summary",kFinancialDetailArrKey: arrCash])
        arrFinancialData.add([kHeaderTitleKey: "Financial Statement",kFinancialDetailArrKey: arrStatement])
        arrFinancialData.add([kHeaderTitleKey: "Tax Document",kFinancialDetailArrKey: arrTaxDocument])
        
        tblFinance.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSettingsClicked(sender: UIButton) {
        
    }
    
    @IBAction func btnMenuClicked(sender: UIButton){
//        _ = self.navigationController?.popViewController(animated: true)

        SJSwiftSideMenuController.showLeftMenu()

    }
    
    func downClicked(sender: UIButton) {
        isMore = (isMore == true) ? false : true
        self.tblFinance.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    //MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrFinancialData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dict : NSDictionary = arrFinancialData[section] as! NSDictionary
        if section == 0 {
            if isMore
            {
                if let arr = dict.value(forKey: kFinancialDetailArrKey){
                    let tmpArray = arr as! NSMutableArray
                    return tmpArray.count
                }
            }
            else
            {
                return 1
            }
        }
        else {
            if let arr = dict.value(forKey: kFinancialDetailArrKey){
                let tmpArray = arr as! NSMutableArray
                return tmpArray.count
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 44
            }
            else
            {
                return 44
            }
        }
        return UITableViewAutomaticDimension//39
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : financialHeaderCell = tableView.dequeueReusableCell(withIdentifier: kFinancialHeaderCellIdentifier) as! financialHeaderCell
        let dict : NSDictionary = arrFinancialData[section] as! NSDictionary
        if let name = dict.value(forKey: kHeaderTitleKey){
            cell.lblTitle.text = "\(name)"
        }
        return cell.contentView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mainCell = UITableViewCell()
        if indexPath.section == 0 {
            if indexPath.row ==  0 {
                let cell : cashMainCell = tableView.dequeueReusableCell(withIdentifier: kFinancialCashMainCellIdentifier, for: indexPath) as! cashMainCell
                let dictMain : NSDictionary = arrFinancialData[indexPath.section] as! NSDictionary
                let dicCompany : NSDictionary = (dictMain.value(forKey: kFinancialDetailArrKey) as! NSArray).object(at: indexPath.row) as! NSDictionary
                cell.btnShow.addTarget(self, action: #selector (self.downClicked(sender:)), for: .touchUpInside)
                if let name = dicCompany.value(forKey: kFinancialCompanyNameKey) {
                    cell.lblTitle.text = "\(name)"
                }
                if let amount = dicCompany.value(forKey: kFinancialCompanyAmountKey) {
                    cell.lblAmount.text = "\(amount)"
                }
                
                if isMore  {
                    cell.imgBottomLine.isHidden = false
                    cell.imgBottomView.isHidden = false
                }
                else
                {
                    cell.imgBottomLine.isHidden = true
                    cell.imgBottomView.isHidden = true
                }
                mainCell = cell
                
            }
            else
            {
                let cell : cashDetailCell = tableView.dequeueReusableCell(withIdentifier: kFinancialCashDetailCellIdentifier, for: indexPath) as! cashDetailCell
                let dictMain : NSDictionary = arrFinancialData[indexPath.section] as! NSDictionary
                let dicCompany : NSDictionary = (dictMain.value(forKey: kFinancialDetailArrKey) as! NSArray).object(at: indexPath.row) as! NSDictionary
                
                if let name = dicCompany.value(forKey: kFinancialCompanyNameKey) {
                    cell.lblCompanyName.text = "\(name)"
                }
                if let amount = dicCompany.value(forKey: kFinancialCompanyAmountKey) {
                    cell.lblAmount.text = "\(amount)"
                }
                
                if (dictMain.value(forKey: kFinancialDetailArrKey) as! NSArray).count == (indexPath.row + 1) {
                    cell.imgTopView.isHidden = false
                    cell.imgBottomView.isHidden = true
                    cell.imgBottomLine.isHidden = true
                    cell.imgTopLine.isHidden = false
                    
                }
                else
                {
                    cell.imgTopView.isHidden = false
                    cell.imgBottomView.isHidden = false
                    cell.imgBottomLine.isHidden = false
                    cell.imgTopLine.isHidden = false
                }
                
                
                mainCell = cell
            }
        }
        else if indexPath.section == 1 {
            let cell : financialDetailCell = tableView.dequeueReusableCell(withIdentifier: kFinancialDetailIdentifier, for: indexPath) as! financialDetailCell
            let dictMain : NSDictionary = arrFinancialData[indexPath.section] as! NSDictionary
            let dicCompany : NSDictionary = (dictMain.value(forKey: kFinancialDetailArrKey) as! NSArray).object(at: indexPath.row) as! NSDictionary
            
            
            if indexPath.row == 0 {
                cell.vwTop.isHidden = true
                cell.vwBottom.isHidden = false
            }
            else if (dictMain.value(forKey: kFinancialDetailArrKey) as! NSArray).count == (indexPath.row + 1) {
                cell.vwTop.isHidden = false
                cell.vwBottom.isHidden = true
            }
            else
            {
                cell.vwTop.isHidden = false
                cell.vwBottom.isHidden = false
            }
            
            if let name = dicCompany.value(forKey: kFinancialCompanyNameKey) {
                cell.lblTitle.text = "\(name)"
            }
            if let desc = dicCompany.value(forKey: kFinancialCompanyDescKey) {
                cell.lblDescription.text = "\(desc)"
            }
            
            mainCell = cell
        }
        else if indexPath.section == 2 {
            let cell : financialDetailCell = tableView.dequeueReusableCell(withIdentifier: kFinancialDetailIdentifier, for: indexPath) as! financialDetailCell
            let dictMain : NSDictionary = arrFinancialData[indexPath.section] as! NSDictionary
            let dicCompany : NSDictionary = (dictMain.value(forKey: kFinancialDetailArrKey) as! NSArray).object(at: indexPath.row) as! NSDictionary
            if indexPath.row == 0 {
                cell.vwTop.isHidden = true
                cell.vwBottom.isHidden = false
            }
            else if (dictMain.value(forKey: kFinancialDetailArrKey) as! NSArray).count == (indexPath.row + 1) {
                cell.vwTop.isHidden = false
                cell.vwBottom.isHidden = true
            }
            else
            {
                cell.vwTop.isHidden = false
                cell.vwBottom.isHidden = false
            }
            
            if let name = dicCompany.value(forKey: kFinancialCompanyNameKey) {
                cell.lblTitle.text = "\(name)"
            }
            cell.lblDescription.text = ""
            
            
            mainCell = cell
        }
        
        return mainCell
    }
}

class financialHeaderCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
}

class financialDetailCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwBottom: UIView!
}
class cashMainCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBottomLine: UIImageView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var imgBottomView: UIImageView!
}
class cashDetailCell : UITableViewCell {
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var imgBottomLine: UIImageView!
    @IBOutlet weak var imgTopLine: UIImageView!
    @IBOutlet weak var imgTopView: UIImageView!
    @IBOutlet weak var imgBottomView: UIImageView!
}
