//
//  EntitiesViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class EntitiesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tblEntity: UITableView!
    //var intType : Int = 0
    var arrEntityData = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tblEntity.estimatedRowHeight = 100.0
        self.tblEntity.rowHeight = UITableViewAutomaticDimension
        setTemporaryData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Tableview Delegate methods
    
    func setTemporaryData() {
        arrEntityData = NSMutableArray()
        
       
        
        arrEntityData.add([kTitleKey: "Fund01",kDescriptionKey: "This is new description that has been written"])
        arrEntityData.add([kTitleKey: "Fund02",kDescriptionKey: "This is new description that has been written"])
        arrEntityData.add([kTitleKey: "Fund03",kDescriptionKey: "lorem ipsum is a filler text or greeking commonly used to demonstrate the textual elements of a graphic document or visual presentation."])
        arrEntityData.add([kTitleKey: "Fund04",kDescriptionKey: "This is new description that has been written in order to check whether it if functionging or not"])
        arrEntityData.add([kTitleKey: "Fund05",kDescriptionKey: "This is new description that has been written"])
        arrEntityData.add([kTitleKey: "Fund06",kDescriptionKey: "This is new description that has been written"])
        arrEntityData.add([kTitleKey: "Fund07",kDescriptionKey: "lorem ipsum is a filler text or greeking commonly used to demonstrate the textual elements of a graphic document or visual presentation."])
        arrEntityData.add([kTitleKey: "Fund08",kDescriptionKey: "This is new description that has been written in order to check whether it if functionging or not"])
            
            
        
        tblEntity.reloadData()
    }
    
    //MARK:- Button Click Action
    @IBAction func btnMenuClicked(sender: UIButton) {
         _ = self.navigationController?.popViewController(animated: true)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
            return UITableViewAutomaticDimension
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : entityCell = tableView.dequeueReusableCell(withIdentifier: kEntityCellIdentifier, for: indexPath) as! entityCell
        let dictEntity : NSDictionary = arrEntityData[indexPath.row] as! NSDictionary
        if let title = dictEntity.value(forKey: kTitleKey) {
            cell.lblTitle.text = "\(title)"
        }
        if let description = dictEntity.value(forKey: kDescriptionKey) {
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




