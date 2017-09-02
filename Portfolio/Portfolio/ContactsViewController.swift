//
//  NewsViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tblNews: UITableView!
    @IBOutlet var txtSearch: UITextField!
    
    var arrContacts = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tblNews.estimatedRowHeight = 200.0
        self.tblNews.rowHeight = UITableViewAutomaticDimension
        setTemporaryData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Tableview Delegate methods
    
    func setTemporaryData() {
        arrContacts = NSMutableArray()
        arrContacts.add([kNameKey: "Anna Watson",kPostKey: "Marketing Manager",kCompanyNameKey: "Aviva",kImageKey: "settings"])
            arrContacts.add([kNameKey: "Berry Mark",kPostKey: "General Manager",kCompanyNameKey: "Birla Sun Life",kImageKey: "settings"])
            arrContacts.add([kNameKey: "Benson Danial",kPostKey: "Assistant Manager",kCompanyNameKey: "HDFC Life Insurance",kImageKey: "settings"])
            arrContacts.add([kNameKey: "David Hall",kPostKey: "Sales Executive",kCompanyNameKey: "General Electronics",kImageKey: "settings"])
            arrContacts.add([kNameKey: "Elle Susan",kPostKey: "CEO & Founder",kCompanyNameKey: "Abc Finance",kImageKey: "settings"])
            arrContacts.add([kNameKey: "Harry Carter",kPostKey: "General Manager",kCompanyNameKey: "Aviva",kImageKey: "settings"])
        tblNews.reloadData()
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
        return arrContacts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : contactCell = tableView.dequeueReusableCell(withIdentifier: kContactsCellIdentifier, for: indexPath) as! contactCell
        let dictEntity : NSDictionary = arrContacts[indexPath.row] as! NSDictionary
        if let name = dictEntity.value(forKey: kNameKey) {
            cell.lblName.text = "\(name)"
        }
        if let post = dictEntity.value(forKey: kPostKey) {
            cell.lblPost.text = "\(post)"
        }
        if let company = dictEntity.value(forKey: kCompanyNameKey) {
            cell.lblCompanyName.text = "\(company)"
        }
        
        if let image = dictEntity.value(forKey: kImageKey) {
            //cell.imgPic.image
        }
        return cell
    }
}

class contactCell : UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var imgPic: UIImageView!
}

