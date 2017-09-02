//
//  EntitiesViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class DocumentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tblEntity: UITableView!
    
    var arrDocument = NSMutableArray()
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
        arrDocument = NSMutableArray()
        arrDocument.add([kTitleKey: "Home",kImageKey: "homeIcon"])
        arrDocument.add([kTitleKey: "Insurance",kImageKey: "insuranceIcon"])
        arrDocument.add([kTitleKey: "Auto",kImageKey: "autoIcon"])
        arrDocument.add([kTitleKey: "Credit Card",kImageKey: "cardIcon"])
        arrDocument.add([kTitleKey: "Family",kImageKey: "familyIcon"])
        arrDocument.add([kTitleKey: "Education",kImageKey: "educationIcon"])
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
        return arrDocument.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : documentCell = tableView.dequeueReusableCell(withIdentifier: kDocumentCellIdentifier, for: indexPath) as! documentCell
        let dictEntity : NSDictionary = arrDocument[indexPath.row] as! NSDictionary
        
        if let title = dictEntity.value(forKey: kTitleKey) {
            cell.lblTitle.text = "\(title)"
        }
        
        if let img = dictEntity.value(forKey: kImageKey) {
            cell.imgTopic.image = UIImage(named: "\(img)")
        }
        return cell
    }
}
//MARK:- Cell for displaying document
class documentCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgTopic: UIImageView!
}


