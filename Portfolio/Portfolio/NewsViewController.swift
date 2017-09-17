//
//  NewsViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Niyati. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tblNews: UITableView!
    
    @IBOutlet var txtSearch: UITextField!
    var arrNews = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)

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
        arrNews = NSMutableArray()
        arrNews.add([kTitleKey: "Vivamus porta ipsum et fermentum",kDescriptionKey: "C'est une nouvelle description qui a été entrée à chek",kDateKey: "25/02/2017"])
        arrNews.add([kTitleKey: "Maecansn pellentesque fringilla erat",kDescriptionKey: "Bonjour, passez une journée merveilleuse à venir",kDateKey: "25/11/2017"])
        arrNews.add([kTitleKey: "Vivamus at loren ut insiki dictum",kDescriptionKey: "lorem ipsum est un texte de remplissage ou un greeking couramment utilisé pour démontrer les éléments textuels d'un document graphique ou d'une présentation visuelle.",kDateKey: "25/11/2017"])
        arrNews.add([kTitleKey: "Donec sed lulla loretta, mollis metus",kDescriptionKey: "Une variation du texte ordinaire de lorem ipsum a été utilisée dans la composition depuis les années 1960 ou plus tôt, alors qu'elle était popularisée par des publicités pour les feuilles de transfert Letraset.",kDateKey: "25/11/2017"])
        arrNews.add([kTitleKey: "Fund05",kDescriptionKey: "This is new description that has been written",kDateKey: "25/11/2017"])
        arrNews.add([kTitleKey: "Fund06",kDescriptionKey: "This is new description that has been written",kDateKey: "25/11/2017"])
        arrNews.add([kTitleKey: "Fund07",kDescriptionKey: "lorem ipsum is a filler text or greeking commonly used to demonstrate the textual elements of a graphic document or visual presentation.",kDateKey: "25/11/2017"])
        arrNews.add([kTitleKey: "Fund08",kDescriptionKey: "This is new description that has been written in order to check whether it if functionging or not",kDateKey: "25/11/2017"])
        tblNews.reloadData()
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
        print("Searching data")
        
    }
    
    //MARK:-
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNews.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : newsCell = tableView.dequeueReusableCell(withIdentifier: kNewsCellIdentifier, for: indexPath) as! newsCell
        let dictEntity : NSDictionary = arrNews[indexPath.row] as! NSDictionary
        
        
        if let title = dictEntity.value(forKey: kTitleKey) {
            cell.lblTitle.text = "\(title)"
            cell.lblTitle.sizeToFit()
        }
        if let description = dictEntity.value(forKey: kDescriptionKey) {
            cell.lblDescription.text = "\(description)"
            cell.lblDescription.sizeToFit()
        }
        if let date = dictEntity.value(forKey: kDateKey) {
            cell.lblDate.text = "\(date)"
        }
        return cell
    }
}

class newsCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
}


