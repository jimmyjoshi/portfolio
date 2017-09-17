//
//  EntitiesViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tblTeam: UITableView!
    @IBOutlet var txtSearch: UITextField!
    var arrTeam = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tblTeam.estimatedRowHeight = 100.0
        self.tblTeam.rowHeight = UITableViewAutomaticDimension
        setTemporaryData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Tableview Delegate methods
    
    func setTemporaryData() {
        arrTeam = NSMutableArray()
        arrTeam.add([kTeamNameKey: "Accell",kTeamDescriptionKey: "Lorel ipsum sit amet conceptures",kTeamImageKey: "",kTeamStarKey: 5])
        arrTeam.add([kTeamNameKey: "Fund02",kTeamDescriptionKey: "Suspendisse cursus felis ut enim ",kTeamImageKey: "",kTeamStarKey: 4])
        arrTeam.add([kTeamNameKey: "Blume Ventures",kTeamDescriptionKey: "Maecenus sit amet elit nec turpis",kTeamImageKey: "",kTeamStarKey: 3])
        arrTeam.add([kTeamNameKey: "IDG Ventures",kTeamDescriptionKey: "Pelletensque lectus dui, suscipt",kTeamImageKey: "",kTeamStarKey: 2])
        arrTeam.add([kTeamNameKey: "Naspers",kTeamDescriptionKey: "Qui at digisom",kTeamImageKey: "",kTeamStarKey: 1])
        arrTeam.add([kTeamNameKey: "SteadView Capital",kTeamDescriptionKey: "Mascellea vitro chimpa",kTeamImageKey: "",kTeamStarKey: 0])
        
        tblTeam.reloadData()
    }
    
    //MARK:- Button Click Action
    @IBAction func btnMenuClicked(sender: UIButton) {
//        _ = self.navigationController?.popViewController(animated: true)
        SJSwiftSideMenuController.showLeftMenu()

    }
    
    @IBAction func btnSettingsClicked(sender: UIButton) {
        
    }
    
    @IBAction func btnSearchClicked(sender: UIButton) {
        self.view.endEditing(true)
        
    }
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTeam.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objTeamDetail  : TeamDetailViewController = storyTab.instantiateViewController(withIdentifier: "TeamDetailViewController") as! TeamDetailViewController
        self.navigationController?.pushViewController(objTeamDetail, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : teamCell = tableView.dequeueReusableCell(withIdentifier: kTeamCellIdentifier, for: indexPath) as! teamCell
        let dictEntity : NSDictionary = arrTeam[indexPath.row] as! NSDictionary
        
        if let img = dictEntity.value(forKey: kTeamImageKey) {
            //cell.lb.text = "\(title)"
        }
        
        if let name = dictEntity.value(forKey: kTeamNameKey) {
            cell.lblName.text = "\(name)"
        }
        
        if let description = dictEntity.value(forKey: kTeamDescriptionKey)
        {
            cell.lblDescription.text = "\(description)"
        }
        
        if let star = dictEntity.value(forKey: kTeamStarKey) {
            var intStar : Int = star as! Int
            
            cell.imgStar1.image = UIImage(named: (1 <= intStar) ? "StarSelected" : "StarUnSelected")
            cell.imgStar2.image = UIImage(named: (2 <= intStar) ? "StarSelected" : "StarUnSelected")
            cell.imgStar3.image = UIImage(named: (3 <= intStar) ? "StarSelected" : "StarUnSelected")
            cell.imgStar4.image = UIImage(named: (4 <= intStar) ? "StarSelected" : "StarUnSelected")
            cell.imgStar5.image = UIImage(named: (5 <= intStar) ? "StarSelected" : "StarUnSelected")
            
            
            /*
            
            if intStar == 0 {
                cell.imgStar1.image = UIImage(named: "StarUnSelected")
                cell.imgStar2.image = UIImage(named: "StarUnSelected")
                cell.imgStar3.image = UIImage(named: "StarUnSelected")
                cell.imgStar4.image = UIImage(named: "StarUnSelected")
                cell.imgStar5.image = UIImage(named: "StarUnSelected")
                
            }
            else if intStar == 1 {
                cell.imgStar1.image = UIImage(named: "StarSelected")
                cell.imgStar2.image = UIImage(named: "StarUnSelected")
                cell.imgStar3.image = UIImage(named: "StarUnSelected")
                cell.imgStar4.image = UIImage(named: "StarUnSelected")
                cell.imgStar5.image = UIImage(named: "StarUnSelected")
            }
            else if intStar == 2 {
                cell.imgStar1.image = UIImage(named: "StarSelected")
                cell.imgStar2.image = UIImage(named: "StarSelected")
                cell.imgStar3.image = UIImage(named: "StarUnSelected")
                cell.imgStar4.image = UIImage(named: "StarUnSelected")
                cell.imgStar5.image = UIImage(named: "StarUnSelected")
            }
            else if intStar == 3 {
                cell.imgStar1.image = UIImage(named: "StarSelected")
                cell.imgStar2.image = UIImage(named: "StarSelected")
                cell.imgStar3.image = UIImage(named: "StarSelected")
                cell.imgStar4.image = UIImage(named: "StarUnSelected")
                cell.imgStar5.image = UIImage(named: "StarUnSelected")
            }
            else if intStar == 4 {
                cell.imgStar1.image = UIImage(named: "StarSelected")
                cell.imgStar2.image = UIImage(named: "StarSelected")
                cell.imgStar3.image = UIImage(named: "StarSelected")
                cell.imgStar4.image = UIImage(named: "StarSelected")
                cell.imgStar5.image = UIImage(named: "StarUnSelected")
            }
            else if intStar == 5 {
                cell.imgStar1.image = UIImage(named: "StarSelected")
                cell.imgStar2.image = UIImage(named: "StarSelected")
                cell.imgStar3.image = UIImage(named: "StarSelected")
                cell.imgStar4.image = UIImage(named: "StarSelected")
                cell.imgStar5.image = UIImage(named: "StarUnSelected")
            }*/
            
        }
        return cell
    }
}

//MARK:- Cell for displaying entity
class teamCell : UITableViewCell {
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgStar1: UIImageView!
    @IBOutlet weak var imgStar2: UIImageView!
    @IBOutlet weak var imgStar3: UIImageView!
    @IBOutlet weak var imgStar4: UIImageView!
    @IBOutlet weak var imgStar5: UIImageView!
}




