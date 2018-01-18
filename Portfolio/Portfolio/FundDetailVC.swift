//
//  FundDetailVC.swift
//  Portfolio
//
//  Created by Yash on 09/01/18.
//  Copyright © 2018 Niyati. All rights reserved.
//

import UIKit

class FundDetailVC: UIViewController
{
    var dictFundDetails = NSDictionary()
    var arrCompanyData = NSMutableArray()
    var arrContactData = NSMutableArray()
    var arrdocuments = NSMutableArray()
    var arrNotes = NSMutableArray()
    var arrtoDos = NSMutableArray()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func getFundDetails()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetFundDetails
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let parameters: [String: Any] = ["fundId": "\(self.dictFundDetails.value(forKey: "entityId")!)"]
        
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
                                
                            }
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrCompanyData = NSMutableArray()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
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
