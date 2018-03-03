//
//  EntitiesViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblEntity: UITableView!
    
    var arrDocument = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
        self.getAllDocumentCategories()
    }
    func getAllDocumentCategories()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kdocumentCategories
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
                            self.arrDocument = NSMutableArray()
                            self.tblEntity.reloadData()
                            
                            let msg = ((dictemp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.arrDocument = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                            self.tblEntity.reloadData()
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrDocument = NSMutableArray()
                self.tblEntity.reloadData()
                
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tblEntity.estimatedRowHeight = 100.0
        self.tblEntity.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Tableview Delegate methods
    
    func setTemporaryData() {
        self.arrDocument = NSMutableArray()
        /*
        arrDocument.add([kTitleKey: "Home",kImageKey: "homeIcon"])
        arrDocument.add([kTitleKey: "Insurance",kImageKey: "insuranceIcon"])
        arrDocument.add([kTitleKey: "Auto",kImageKey: "autoIcon"])
        arrDocument.add([kTitleKey: "Credit Card",kImageKey: "cardIcon"])
        arrDocument.add([kTitleKey: "Family",kImageKey: "familyIcon"])
        arrDocument.add([kTitleKey: "Education",kImageKey: "educationIcon"])*/
        self.tblEntity.reloadData()
    }
    
    //MARK:- Button Click Action
    @IBAction func btnMenuClicked(sender: UIButton) {
//        _ = self.navigationController?.popViewController(animated: true)
        SJSwiftSideMenuController.showLeftMenu()

    }
    
    @IBAction func btnSettingsClicked(sender: UIButton) {
        
    }
    
    
    //MARK:- tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDocument.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dictEntity : NSDictionary = arrDocument[indexPath.row] as! NSDictionary
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objFin : DocumentsDetailsVC = storyTab.instantiateViewController(withIdentifier: "DocumentsDetailsVC") as! DocumentsDetailsVC
        objFin.dictCategory = dictEntity
        self.navigationController?.pushViewController(objFin, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : documentCell = tableView.dequeueReusableCell(withIdentifier: kDocumentCellIdentifier, for: indexPath) as! documentCell
        let dictEntity : NSDictionary = arrDocument[indexPath.row] as! NSDictionary
        
        if let title = dictEntity.value(forKey: ktitlekey)
        {
            cell.lblTitle.text = "\(title)"
        }
        
        /*
        if let strimageLink = dictEntity.value(forKey: kIconKey)
        {
            let strURL : String = (strimageLink as AnyObject).replacingOccurrences(of: " ", with: "%20")
            let url2 = URL(string: strURL)
            if url2 != nil {
                cell.imgTopic.sd_setImage(with: url2, placeholderImage: nil)
            }
        }*/
        return cell
    }
}
//MARK:- Cell for displaying document
class documentCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgTopic: UIImageView!
}


