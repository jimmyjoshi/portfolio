//
//  NewsViewController.swift
//  Portfolio
//
//  Created by Ravi Panicker on 02/09/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate
{
    @IBOutlet var tblNews: UITableView!
    
    @IBOutlet var txtSearch: UITextField!
    var arrNews = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
        
        self.getNews()
    }
    
    func getNews()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetNews
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        
        var parameters = [String: Any]()
        if (self.txtSearch.text?.isEmpty)!
        {
             parameters = ["keyword": ""]
        }
        else
        {
            parameters = ["keyword": "\(self.txtSearch.text!)"]
        }
        
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
                            self.arrNews = NSMutableArray()
                            
                            let msg = ((dictemp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.arrNews = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                        }
                    }
                    self.tblNews.reloadData()
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrNews = NSMutableArray()
                self.tblNews.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tblNews.estimatedRowHeight = 200.0
        self.tblNews.rowHeight = UITableViewAutomaticDimension
//        setTemporaryData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Tableview Delegate methods
    func setTemporaryData()
    {
        arrNews = NSMutableArray()
        arrNews.add([ktitlekey: "Vivamus porta ipsum et fermentum",kDescriptionKey: "C'est une nouvelle description qui a été entrée à chek",kDateKey: "25/02/2017"])
        arrNews.add([ktitlekey: "Maecansn pellentesque fringilla erat",kDescriptionKey: "Bonjour, passez une journée merveilleuse à venir",kDateKey: "25/11/2017"])
        arrNews.add([ktitlekey: "Vivamus at loren ut insiki dictum",kDescriptionKey: "lorem ipsum est un texte de remplissage ou un greeking couramment utilisé pour démontrer les éléments textuels d'un document graphique ou d'une présentation visuelle.",kDateKey: "25/11/2017"])
        arrNews.add([ktitlekey: "Donec sed lulla loretta, mollis metus",kDescriptionKey: "Une variation du texte ordinaire de lorem ipsum a été utilisée dans la composition depuis les années 1960 ou plus tôt, alors qu'elle était popularisée par des publicités pour les feuilles de transfert Letraset.",kDateKey: "25/11/2017"])
        arrNews.add([ktitlekey: "Fund05",kDescriptionKey: "This is new description that has been written",kDateKey: "25/11/2017"])
        arrNews.add([ktitlekey: "Fund06",kDescriptionKey: "This is new description that has been written",kDateKey: "25/11/2017"])
        arrNews.add([ktitlekey: "Fund07",kDescriptionKey: "lorem ipsum is a filler text or greeking commonly used to demonstrate the textual elements of a graphic document or visual presentation.",kDateKey: "25/11/2017"])
        arrNews.add([ktitlekey: "Fund08",kDescriptionKey: "This is new description that has been written in order to check whether it if functionging or not",kDateKey: "25/11/2017"])
        tblNews.reloadData()
    }
    
    //MARK:- Button Click Action
    @IBAction func btnMenuClicked(sender: UIButton) {
//        _ = self.navigationController?.popViewController(animated: true)
        SJSwiftSideMenuController.showLeftMenu()

    }
    
    @IBAction func btnSettingsClicked(sender: UIButton)
    {
    }
    
    @IBAction func btnSearchClicked(sender: UIButton)
    {
        self.view.endEditing(true)
        print("Searching data")
        self.getNews()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   //delegate method
        textField.resignFirstResponder()
        self.getNews()
        return true
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dictEntity : NSDictionary = arrNews[indexPath.row] as! NSDictionary
        tableView.deselectRow(at: indexPath, animated: true)

        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objFin : OpenEcternalLinkVC = storyTab.instantiateViewController(withIdentifier: "OpenEcternalLinkVC") as! OpenEcternalLinkVC
        objFin.strURL = "\(dictEntity.value(forKey: "link")!)"
        self.navigationController?.pushViewController(objFin, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : newsCell = tableView.dequeueReusableCell(withIdentifier: kNewsCellIdentifier, for: indexPath) as! newsCell
        let dictEntity : NSDictionary = arrNews[indexPath.row] as! NSDictionary
        
        if let title = dictEntity.value(forKey: kNewsTitleKey)
        {
            cell.lblTitle.text = "\(title)"
            cell.lblTitle.sizeToFit()
        }
        if let description = dictEntity.value(forKey: kNewsDescriptionKey)
        {
            cell.lblDescription.text = "\(description)"
            cell.lblDescription.sizeToFit()
        }
        if let date = dictEntity.value(forKey: kNewsDateKey)
        {
            cell.lblDate.text = "\(date)"
        }
        cell.layoutIfNeeded()
        return cell
    }
}

class newsCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
}


