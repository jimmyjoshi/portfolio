//
//  EntitiesViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class EntitiesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tblEntity: UITableView!
    //var intType : Int = 0
    var arrEntityData = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)

        self.getAllEntities()
        // Do any additional setup after loading the view.
    }
    func getAllEntities()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kgetAllEntities
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
                            self.arrEntityData = NSMutableArray()
                            self.tblEntity.reloadData()

                            let msg = ((dictemp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.arrEntityData = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                            self.tblEntity.reloadData()
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrEntityData = NSMutableArray()
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
        
       
        /*
        arrEntityData.add([kTitleKey: "Fund01",kDescriptionKey: "This is new description that has been written"])
        arrEntityData.add([kTitleKey: "Fund02",kDescriptionKey: "This is new description that has been written"])
        arrEntityData.add([kTitleKey: "Fund03",kDescriptionKey: "lorem ipsum is a filler text or greeking commonly used to demonstrate the textual elements of a graphic document or visual presentation."])
        arrEntityData.add([kTitleKey: "Fund04",kDescriptionKey: "This is new description that has been written in order to check whether it if functionging or not"])
        arrEntityData.add([kTitleKey: "Fund05",kDescriptionKey: "This is new description that has been written"])
        arrEntityData.add([kTitleKey: "Fund06",kDescriptionKey: "This is new description that has been written"])
        arrEntityData.add([kTitleKey: "Fund07",kDescriptionKey: "lorem ipsum is a filler text or greeking commonly used to demonstrate the textual elements of a graphic document or visual presentation."])
        arrEntityData.add([kTitleKey: "Fund08",kDescriptionKey: "This is new description that has been written in order to check whether it if functionging or not"])
            
            */
    }
    
    
    //MARK:- Button Click Action
    @IBAction func btnMenuClicked(sender: UIButton) {
//         _ = self.navigationController?.popViewController(animated: true)
        SJSwiftSideMenuController.showLeftMenu()

    }
    
    @IBAction func btnSettingsClicked(sender: UIButton) {
        
    }

    
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEntityData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objEntityDetail  : EntityDetailViewController = storyTab.instantiateViewController(withIdentifier: "EntityDetailViewController") as! EntityDetailViewController
        objEntityDetail.dictFundDetails = arrEntityData[indexPath.row] as! NSDictionary
        self.navigationController?.pushViewController(objEntityDetail, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : entityCell = tableView.dequeueReusableCell(withIdentifier: kEntityCellIdentifier, for: indexPath) as! entityCell
        let dictEntity : NSDictionary = arrEntityData[indexPath.row] as! NSDictionary
        if let title = dictEntity.value(forKey: ktitlekey)
        {
            cell.lblTitle.text = "\(title)"
        }
        if let description = dictEntity.value(forKey: kDescriptionKey)
        {
            cell.lblDescription.text = "\(description)"
            cell.lblDescription.sizeToFit()
        }
        return cell
    }
}

//MARK:- Cell for displaying entity
class entityCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
}




