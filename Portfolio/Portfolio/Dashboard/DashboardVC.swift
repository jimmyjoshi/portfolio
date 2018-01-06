//
//  DashboardVC.swift
//  Portfolio
//
//  Created by Kevin on 30/08/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {

    @IBOutlet var colNews: UICollectionView!
    @IBOutlet var pgControl: UIPageControl!
    var arrNews = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true

        SJSwiftSideMenuController.enableDimBackground = true
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)

        setTemporaryData()
        // Do any additional setup after loading the view.
        self.getNews()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNews()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetNews
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let parameters: [String: Any] = ["keyword": ""]

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
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrNews = NSMutableArray()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }
    
    func setTemporaryData() {
        arrNews = NSMutableArray()
        arrNews.add([kNewsTitleKey: "Lorel Ipsum delivat checko",kNewsDescriptionKey: "Porin pursus ex, accumsain at maximus non, Curabitus fermentum cursus quis nulla.",kNewsDateKey: "24Jan,17"])
        arrNews.add([kNewsTitleKey: "Delivat checko Lorel Ipsum",kNewsDescriptionKey: "Porin pursus ex, accumsain at maximus non, Curabitus fermentum cursus quis nulla.",kNewsDateKey: "29Jan,17"])
        pgControl.currentPage = 0
        pgControl.numberOfPages = arrNews.count
        colNews.reloadData()
        
    }
    @IBAction func btnMenuClicked(sender: UIButton) {
        //         _ = self.navigationController?.popViewController(animated: true)
        SJSwiftSideMenuController.showLeftMenu()
        
    }
    
    @IBAction func btnEntitiesClicked(sender: UIButton)
    {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objEntity  : EntitiesViewController = storyTab.instantiateViewController(withIdentifier: "EntitiesViewController") as! EntitiesViewController
        self.navigationController?.pushViewController(objEntity, animated: true)
    }

    @IBAction func btnTeamClicked(sender: UIButton) {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objTeam  : TeamViewController = storyTab.instantiateViewController(withIdentifier: "TeamViewController") as! TeamViewController
        self.navigationController?.pushViewController(objTeam, animated: true)
    }
    
    @IBAction func btnNewsClicked(sender: UIButton) {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objNewsVC : NewsViewController = storyTab.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        self.navigationController?.pushViewController(objNewsVC, animated: true)
    }
    
    @IBAction func btnCompaniesClicked(sender: UIButton) {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objCompanies : CompanyViewController = storyTab.instantiateViewController(withIdentifier: "CompanyViewController") as! CompanyViewController
        self.navigationController?.pushViewController(objCompanies, animated: true)
    }
    
    @IBAction func btnDocumentsClicked(sender: UIButton) {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objEntity  : DocumentsViewController = storyTab.instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
        self.navigationController?.pushViewController(objEntity, animated: true)
    }
    
    @IBAction func btnContactsClicked(sender: UIButton) {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objNewsVC : ContactsViewController = storyTab.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
        self.navigationController?.pushViewController(objNewsVC, animated: true)
    }
    
    @IBAction func btnFinancialClicked(sender: UIButton) {
        let storyTab = UIStoryboard(name: "Main", bundle: nil)
        let objFin : FinancialSummaryViewController = storyTab.instantiateViewController(withIdentifier: "FinancialSummaryViewController") as! FinancialSummaryViewController
        self.navigationController?.pushViewController(objFin, animated: true)
    }
    
    //MARK:- Collection View delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellNews = collectionView.dequeueReusableCell(withReuseIdentifier: kNewsCollCellIdentifier, for: indexPath) as! newsCollCell
        
        let dict : NSDictionary = arrNews[indexPath.row] as! NSDictionary
        
        if let title = dict.value(forKey: kNewsTitleKey) {
            cellNews.lblTitle.text = "\u{2022} \(title)"
        }
        if let desc = dict.value(forKey: kNewsDescriptionKey) {
            cellNews.lblDescription.text = "\(desc)"
        }
        if let date = dict.value(forKey: kNewsDateKey) {
            cellNews.lblDate.text = "\(date)"
        }
        return cellNews
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: MainScreen.width - 64, height: 92)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the new page index depending on the content offset.
        let width = scrollView.bounds.width
        let page = (scrollView.contentOffset.x + (0.5 * width)) / width
        pgControl.currentPage = Int(page)
    }

}

class newsCollCell : UICollectionViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblDate: UILabel!
}
