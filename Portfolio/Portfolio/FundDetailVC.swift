//
//  FundDetailVC.swift
//  Portfolio
//
//  Created by Yash on 09/01/18.
//  Copyright © 2018 Niyati. All rights reserved.
//

import UIKit

class FundDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tblFinance: UITableView!

    var dictFundDetails = NSDictionary()
    var arrCompanyData = NSMutableArray()
    var arrContactData = NSMutableArray()
    var arrdocuments = NSMutableArray()
    var arrNotes = NSMutableArray()
    var arrtoDos = NSMutableArray()
    var arrMainData = NSMutableArray()
    var dictMain = NSDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblFinance.estimatedRowHeight = 200.0
        self.tblFinance.rowHeight = UITableViewAutomaticDimension

        self.getFundDetails()
    }
    func getFundDetails()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetFundDetails
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let parameters: [String: Any] = ["fundId": "\(self.dictFundDetails.value(forKey: "fundId")!)"]
        
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
                                /*
                                self.lblEntityName.text = dictdata.value(forKey: "fundTitle") as? String
                                self.lblEntityDetail.text = dictdata.value(forKey: "description") as? String
                                
                                self.lblInceptionDate.text = dictdata.value(forKey: "inceptionDate") as? String
                                self.lblFundSize.text = "$\(dictdata.value(forKey: "fundSize") as! NSNumber)"
                                self.lblTotalInvested.text = "$\(dictdata.value(forKey: "totalInvested") as! NSNumber)"
                                self.lblAssetClass.text = dictdata.value(forKey: "assetClass") as? String*/
                                
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
                                
                                if let tempContacts = dictdata.value(forKey: "contacts") as? NSArray
                                {
                                    self.arrContactData = NSMutableArray(array: tempContacts)
                                }

                                if let tempContacts = dictdata.value(forKey: "documents") as? NSArray
                                {
                                    self.arrdocuments = NSMutableArray(array: tempContacts)
                                }

                                if let tempContacts = dictdata.value(forKey: "notes") as? NSArray
                                {
                                    self.arrNotes = NSMutableArray(array: tempContacts)
                                }

                                if let tempContacts = dictdata.value(forKey: "toDos") as? NSArray
                                {
                                    self.arrtoDos = NSMutableArray(array: tempContacts)
                                }
                                
                                var dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("MainCell", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue("", forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(1, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)
                                
                                dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("Key Contact", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue(self.arrContactData, forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(self.arrContactData.count, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)
                                
                                
                                dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("Documents", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue(self.arrdocuments, forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(self.arrdocuments.count, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)

                                dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("Notes", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue(self.arrNotes, forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(self.arrNotes.count, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)
                                
                                dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("To Do List", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue(self.arrtoDos, forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(self.arrtoDos.count, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)

                                self.tblFinance.reloadData()
//                                self.arrMainData.add([kHeaderTitleKey: "Cash Summary",kFinancialDetailArrKey: self.arrCash])
//                                self.arrFinancialData.add([kHeaderTitleKey: "Financial Statement",kFinancialDetailArrKey: self.arrStatement])
//                                self.arrFinancialData.add([kHeaderTitleKey: "Tax Document",kFinancialDetailArrKey: self.arrTaxDocument])
                            }
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrMainData = NSMutableArray()
                self.tblFinance.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    @IBAction func btnMenuClicked(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.arrMainData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let dict : NSMutableDictionary = self.arrMainData[section] as! NSMutableDictionary
        if dict.value(forKey: kkeyisExpand) as! Int == 1
        {
            if section == 0
            {
                return 1
            }
            else
            {
                if let arr = dict.value(forKey: kkeyDataKey)
                {
                    let tmpArray = arr as! NSMutableArray
                    return tmpArray.count + 1
                }
                return 1
            }
        }
        else
        {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var mainCell = UITableViewCell()
        if indexPath.section == 0
        {
            if indexPath.row ==  0
            {
                let cell : fundDetailCell1 = tableView.dequeueReusableCell(withIdentifier: "fundDetailCell1", for: indexPath) as! fundDetailCell1
                
                cell.lblTitle.text = "\(self.dictMain.value(forKey: "description")!)"
                cell.lblDate.text = "\(self.dictMain.value(forKey: "inceptionDate")!)"
                cell.lblAmount.text = "$\(dictMain.value(forKey: "totalInvested") as! NSNumber)"
                let iPercentage = (Int((dictMain.value(forKey: "totalInvested") as! NSNumber)) * 100) / Int(dictMain.value(forKey: "fundSize") as! NSNumber)
                cell.lblPercentage.text = "\(iPercentage)%"
                
                mainCell = cell
            }
        }
        else if indexPath.section == 1
        {
            let dictrowdata : NSDictionary = self.arrMainData[indexPath.section] as! NSDictionary
            if indexPath.row == 0
            {
                let cell : fundDetailTitleCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailTitleCell", for: indexPath) as! fundDetailTitleCell
                cell.lblTitle.text = "\(dictrowdata.value(forKey: kHeaderTitleKey)!)"
                mainCell = cell
            }
            else
            {
                let dicContact : NSDictionary = (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).object(at: indexPath.row-1) as! NSDictionary
                
                let cell : fundDetailContactCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailContactCell", for: indexPath) as! fundDetailContactCell
                cell.lblTitle.text = "\(dicContact.value(forKey: "title")!)"
                cell.lblSubTitle.text = "\(dicContact.value(forKey: "company")!)"
                mainCell = cell
            }
        }
        else if indexPath.section == 2
        {
            let dictrowdata : NSDictionary = self.arrMainData[indexPath.section] as! NSDictionary
            if indexPath.row == 0
            {
                let cell : fundDetailTitleCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailTitleCell", for: indexPath) as! fundDetailTitleCell
                cell.lblTitle.text = "\(dictrowdata.value(forKey: kHeaderTitleKey)!)"
                mainCell = cell
            }
            else
            {
                let dicContact : NSDictionary = (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).object(at: indexPath.row-1) as! NSDictionary
                
                let cell : fundDetailDocumentsCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailDocumentsCell", for: indexPath) as! fundDetailDocumentsCell
                cell.lblTitle.text = "\(dicContact.value(forKey: "title")!)"
                cell.lblSubTitle.text = "\(dicContact.value(forKey: "description")!)"
                cell.lblOrganisation.text = "\(dicContact.value(forKey: "category")!)"
                mainCell = cell
            }
        }
        else if indexPath.section == 3
        {
            let dictrowdata : NSDictionary = self.arrMainData[indexPath.section] as! NSDictionary
            if indexPath.row == 0
            {
                let cell : fundDetailTitleCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailTitleCell", for: indexPath) as! fundDetailTitleCell
                cell.lblTitle.text = "\(dictrowdata.value(forKey: kHeaderTitleKey)!)"
                mainCell = cell
            }
            else
            {
                let dicContact : NSDictionary = (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).object(at: indexPath.row-1) as! NSDictionary
                
                let cell : fundDetailNotesCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailNotesCell", for: indexPath) as! fundDetailNotesCell
//                cell.lblDate.text = "\(dicContact.value(forKey: "created")!)"
                cell.lblDescription.text = "\(dicContact.value(forKey: "description")!)"
                cell.lblName.text = "-\(dicContact.value(forKey: "title_by")!)"
                mainCell = cell
            }
        }
        else if indexPath.section == 4
        {
            let dictrowdata : NSDictionary = self.arrMainData[indexPath.section] as! NSDictionary
            if indexPath.row == 0
            {
                let cell : fundDetailTitleCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailTitleCell", for: indexPath) as! fundDetailTitleCell
                cell.lblTitle.text = "\(dictrowdata.value(forKey: kHeaderTitleKey)!)"
                mainCell = cell
            }
            else
            {
                let dicContact : NSDictionary = (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).object(at: indexPath.row-1) as! NSDictionary
                
                let cell : fundDetailToDoCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailToDoCell", for: indexPath) as! fundDetailToDoCell
                cell.lblDate.text = "\(dicContact.value(forKey: "created")!)"
                cell.lblDescription.text = "\(dicContact.value(forKey: "notes")!)"
                cell.lblName.text = "-\(dicContact.value(forKey: "title")!)"
                mainCell = cell
            }
        }

        return mainCell
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//MARK: Cell Defination
class fundDetailCell1 : UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwBottom: UIView!
}
class fundDetailTitleCell : UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var imgBottomView: UIImageView!
}
class fundDetailContactCell : UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
}
class fundDetailDocumentsCell : UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblOrganisation: UILabel!
}
class fundDetailNotesCell : UITableViewCell
{
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNameHeightCT: NSLayoutConstraint!
}
class fundDetailToDoCell : UITableViewCell
{
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblName: UILabel!
}
