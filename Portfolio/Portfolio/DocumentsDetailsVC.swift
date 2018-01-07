//
//  DocumentsDetailsVC.swift
//  Portfolio
//
//  Created by Yash on 07/01/18.
//  Copyright © 2018 Niyati. All rights reserved.
//

import UIKit

class DocumentsDetailsVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet var tblDocumentDetail : UITableView!
    var arrDocument = NSMutableArray()
    var dictCategory = NSDictionary()
    @IBOutlet var lblTitleofScreen : UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblDocumentDetail.estimatedRowHeight = 100.0
        self.tblDocumentDetail.rowHeight = UITableViewAutomaticDimension

        lblTitleofScreen.text = "\(dictCategory.value(forKey: ktitlekey)!) Details"
        self.getDocumentDetails()
    }
    
    @IBAction func btnMenuClicked(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getDocumentDetails()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetDocumentsDetails
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let parameters: [String: Any] = ["categoryId": "\(dictCategory.value(forKey: "categoryId")!)"]
        
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
                            self.arrDocument = NSMutableArray()
                            let msg = ((dictemp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            self.arrDocument = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                            self.tblDocumentDetail.reloadData()
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrDocument = NSMutableArray()
                self.tblDocumentDetail.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }
    

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : documentdetailCell = tableView.dequeueReusableCell(withIdentifier: "documentdetailCell", for: indexPath) as! documentdetailCell
        let dictEntity : NSDictionary = arrDocument[indexPath.row] as! NSDictionary
        
        if let ExternalLink = dictEntity.value(forKey: kkeyexternallink)
        {
            cell.lblExternalLink.text = "\(ExternalLink)"
        }

        if let title = dictEntity.value(forKey: ktitlekey)
        {
            cell.lblTitle.text = "\(title)"
        }
        return cell
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
//MARK:- Cell for displaying document
class documentdetailCell : UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblExternalLink: UILabel!

}

