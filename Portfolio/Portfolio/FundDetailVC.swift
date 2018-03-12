//
//  FundDetailVC.swift
//  Portfolio
//
//  Created by Yash on 09/01/18.
//  Copyright © 2018 Niyati. All rights reserved.
//

import UIKit

class FundDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CSPieChartDelegate,CSPieChartDataSource
{

    @IBOutlet weak var tblFinance: UITableView!
    @IBOutlet weak var lblScreenTitle: UILabel!

    var dictFundDetails = NSDictionary()
    var arrCompanyData = NSMutableArray()
    var arrContactData = NSMutableArray()
    var arrdocuments = NSMutableArray()
    var arrNotes = NSMutableArray()
    var arrtoDos = NSMutableArray()
    var arrGraphData = NSMutableArray()
    var arrMainData = NSMutableArray()
    var dictMain = NSDictionary()
    var dataList = NSMutableArray()
    var colorList = NSMutableArray()
    
   /* var dataList = [
        CSPieChartData(key: "test1", value: 30),
        CSPieChartData(key: "test2", value: 30),
        CSPieChartData(key: "test3", value: 30),
        CSPieChartData(key: "test4", value: 30),
        CSPieChartData(key: "test5", value: 30),
        CSPieChartData(key: "test6", value: 30)
    ]
    
    var colorList: [UIColor] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .magenta
    ]*/

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblFinance.estimatedRowHeight = 200.0
        self.tblFinance.rowHeight = UITableViewAutomaticDimension

        lblScreenTitle.text = "\(self.dictFundDetails.value(forKey: "fundTitle")!) Details"
        self.getFundDetails()
    }
    
    func getFundDetails()
    {
        let dic = UserDefaults.standard.value(forKey: kkeyLoginData)
        let final  = NSKeyedUnarchiver .unarchiveObject(with: dic as! Data) as! NSDictionary
        
        let url = kServerURL + kGetCompanyDetails
        showProgress(inView: self.view)
        
        let token = final .value(forKey: "userToken")
        let headers = ["Authorization":"Bearer \(token!)"]
        let parameters: [String: Any] = ["companyId": "\(self.dictFundDetails.value(forKey: "companyId")!)"]
        
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
                            self.arrMainData = NSMutableArray()
                            let msg = ((dictemp.value(forKey: "error") as! NSDictionary) .value(forKey: "reason"))
                            App_showAlert(withMessage: msg as! String, inView: self)
                        }
                        else
                        {
                            //                            self.arrCompanyData = NSMutableArray(array: dictemp.value(forKey: "data") as! NSArray)
                            if let dictdata = dictemp.value(forKey: "data") as? NSDictionary
                            {
                                 self.dictMain = dictdata
                                
                                
                                if let tempContacts = dictdata.value(forKey: "contacts") as? NSArray
                                {
                                    self.arrContactData = NSMutableArray(array: tempContacts)
                                }

                                if let tempdocuments = dictdata.value(forKey: "documents") as? NSArray
                                {
                                    self.arrdocuments = NSMutableArray(array: tempdocuments)
                                }

                                if let tempnotes = dictdata.value(forKey: "notes") as? NSArray
                                {
                                    self.arrNotes = NSMutableArray(array: tempnotes)
                                }

                                if let temptoDos = dictdata.value(forKey: "toDos") as? NSArray
                                {
                                    self.arrtoDos = NSMutableArray(array: temptoDos)
                                }
                                
                                if let tempgraphData = dictdata.value(forKey: "graphData") as? NSArray
                                {
                                    self.arrGraphData = NSMutableArray(array: tempgraphData)
                                }
                                
                                var dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("MainCell", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue("", forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(1, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)
                                
                                dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("Key Contact", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue(self.arrContactData, forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(self.arrContactData.count, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)
                                
                                dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("Cap Table", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue(self.arrGraphData, forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(2+self.arrGraphData.count, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)
                                
                                dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("Documents", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue(self.arrdocuments, forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(self.arrdocuments.count, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)

                                dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("Notes", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue(self.arrNotes, forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(self.arrNotes.count, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)
                                
                                dictmainTemp = NSMutableDictionary()
                                dictmainTemp.setValue("To Do List", forKey: kHeaderTitleKey)
                                dictmainTemp.setValue(self.arrtoDos, forKey: kkeyDataKey)
                                dictmainTemp.setValue(1, forKey: kkeyisExpand)
                                dictmainTemp.setValue(self.arrtoDos.count, forKey: kkeyRowCountKey)
                                self.arrMainData.add(dictmainTemp)
                                
                                for i in 0..<self.arrGraphData.count
                                {
                                    let dicContact : NSDictionary = self.arrGraphData[i] as! NSDictionary
                                    self.dataList.add(CSPieChartData(key: "test\(i)", value: Double(dicContact.value(forKey: "percentage") as! NSNumber)))
                                    self.colorList.add(UIColor(hexString:  "\(dicContact.value(forKey: "color")!)"))
                                }
                                self.tblFinance.reloadData()
//                                self.arrMainData.add([kHeaderTitleKey: "Cash Summary",kFinancialDetailArrKey: self.arrCash])
//                                self.arrFinancialData.add([kHeaderTitleKey: "Financial Statement",kFinancialDetailArrKey: self.arrStatement])
//                                self.arrFinancialData.add([kHeaderTitleKey: "Tax Document",kFinancialDetailArrKey: self.arrTaxDocument])
                                

                                let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
                                
                                DispatchQueue.main.asyncAfter(deadline: when)
                                {
                                    let indexPath = IndexPath(row: self.arrtoDos.count, section: self.arrMainData.count-1)
                                    self.tblFinance.scrollToRow(at: indexPath, at: .bottom, animated: false)
                                }

//                                DispatchQueue.main.asyncAfter(deadline: when)
//                                {
//                                    let indexPath = IndexPath(row: 0, section: 0)
//                                    self.tblFinance.scrollToRow(at: indexPath, at: .top, animated: false)
//                                }

                                DispatchQueue.main.asyncAfter(deadline: when)
                                {
                                    self.tblFinance.reloadData()
                                }
                            }
                        }
                    }
                }
                break
            case .failure(_):
                print(response.result.error!)
                self.arrMainData = NSMutableArray()
                self.tblFinance.reloadData()
                App_showAlert(withMessage: response.result.error.debugDescription, inView: self)
                break
            }
        }
    }

    @IBAction func btnMenuClicked(sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.arrMainData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let dict : NSMutableDictionary = self.arrMainData[section] as! NSMutableDictionary
        if dict.value(forKey: kkeyisExpand) as! Int == 1
        {
            if section == 0
            {
                return 1
            }
            else if section == 2
            {
                if let arr = dict.value(forKey: kkeyDataKey)
                {
                    let tmpArray = arr as! NSMutableArray
                    return tmpArray.count + 2
                }
                return 2
            }
            else
            {
                if let arr = dict.value(forKey: kkeyDataKey)
                {
                    let tmpArray = arr as! NSMutableArray
                    return tmpArray.count + 1
                }
                return 1
            }
        }
        else
        {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var mainCell = UITableViewCell()
        if indexPath.section == 0
        {
            if indexPath.row ==  0
            {
                let cell : fundDetailCell1 = tableView.dequeueReusableCell(withIdentifier: "fundDetailCell1", for: indexPath) as! fundDetailCell1
                
                cell.lblTitle.text = "\(self.dictMain.value(forKey: "description")!)"
                cell.lblDate.text = "\(self.dictMain.value(forKey: "inceptionDate")!)"
                cell.lblAmount.text = "$\(dictMain.value(forKey: "totalInvested") as! NSNumber)"
                let iPercentage = (Int((dictMain.value(forKey: "totalInvested") as! NSNumber)) * 100) / Int(dictMain.value(forKey: "fundSize") as! NSNumber)
                cell.lblPercentage.text = "\(iPercentage)%"
                
                mainCell = cell
            }
        }
        else if indexPath.section == 1
        {
            let dictrowdata : NSDictionary = self.arrMainData[indexPath.section] as! NSDictionary
            if indexPath.row == 0
            {
                let cell : fundDetailTitleCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailTitleCell", for: indexPath) as! fundDetailTitleCell
                cell.lblTitle.text = "\(dictrowdata.value(forKey: kHeaderTitleKey)!)"
                cell.btnShow.addTarget(self, action: #selector(self.collapseexpandCell(_:event:)), for: .touchUpInside)
                
                if dictrowdata.value(forKey: kkeyisExpand) as! Int == 1
                {
                    cell.btnShow.isSelected = true
                    cell.imgBottomView.isHidden = false
                }
                else
                {
                    cell.btnShow.isSelected = false
                    cell.imgBottomView.isHidden = true
                }
                
                mainCell = cell
            }
            else
            {
                let dicContact : NSDictionary = (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).object(at: indexPath.row-1) as! NSDictionary
                
                let cell : fundDetailContactCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailContactCell", for: indexPath) as! fundDetailContactCell
                cell.lblTitle.text = "\(dicContact.value(forKey: "title")!)"
                cell.lblSubTitle.text = "\(dicContact.value(forKey: "designation")!)"
                
                if indexPath.row == (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).count
                {
                    let rectShape = CAShapeLayer()
                    rectShape.bounds = cell.vwContentCell.frame
                    rectShape.position = cell.vwContentCell.center
                    rectShape.path = UIBezierPath(roundedRect: cell.vwContentCell.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
                    
                    cell.vwContentCell.layer.backgroundColor = UIColor.white.cgColor
                    cell.vwContentCell.layer.mask = rectShape
                }
                cell.contentView.setNeedsLayout()
                cell.contentView.layoutIfNeeded()

                mainCell = cell
            }
        }
        else if indexPath.section == 2
        {
            let dictrowdata : NSDictionary = self.arrMainData[indexPath.section] as! NSDictionary
            if indexPath.row == 0
            {
                let cell : fundDetailTitleCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailTitleCell", for: indexPath) as! fundDetailTitleCell
                cell.lblTitle.text = "\(dictrowdata.value(forKey: kHeaderTitleKey)!)"
                cell.btnShow.addTarget(self, action: #selector(self.collapseexpandCell(_:event:)), for: .touchUpInside)
                if dictrowdata.value(forKey: kkeyisExpand) as! Int == 1
                {
                    cell.btnShow.isSelected = true
                    cell.imgBottomView.isHidden = false
                }
                else
                {
                    cell.btnShow.isSelected = false
                    cell.imgBottomView.isHidden = true
                }
                
                mainCell = cell
            }
            else if indexPath.row == 1
            {
                let cell : fundeDetailPieChart = tableView.dequeueReusableCell(withIdentifier: "fundeDetailPieChart", for: indexPath) as! fundeDetailPieChart
                cell.pieChart?.dataSource = self
                cell.pieChart?.delegate = self
                
                cell.pieChart?.pieChartRadiusRate = 0.5
                cell.pieChart?.pieChartLineLength = 12
                cell.pieChart?.seletingAnimationType = .touch
                
                cell.pieChart?.show(animated: true)
                
                mainCell = cell
            }
            else
            {
                let dicContact : NSDictionary = (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).object(at: indexPath.row-2) as! NSDictionary
                
                let cell : fundDetailgraphData = tableView.dequeueReusableCell(withIdentifier: "fundDetailgraphData", for: indexPath) as! fundDetailgraphData
                cell.lblTitle.text = "\(dicContact.value(forKey: "title")!)"
                cell.lblSubTitle.text = "\(dicContact.value(forKey: "subTitle")!)"
                cell.lblPercentage.text = "\(dicContact.value(forKey: "percentage")!)%"
                
                if indexPath.row == (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).count + 1
                {
                    let rectShape = CAShapeLayer()
                    rectShape.bounds = cell.vwContentCell.frame
                    rectShape.position = cell.vwContentCell.center
                    rectShape.path = UIBezierPath(roundedRect: cell.vwContentCell.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
                    
                    cell.vwContentCell.layer.backgroundColor = UIColor.white.cgColor
                    cell.vwContentCell.layer.mask = rectShape
                }
                mainCell = cell
            }
        }
        else if indexPath.section == 3
        {
            let dictrowdata : NSDictionary = self.arrMainData[indexPath.section] as! NSDictionary
            if indexPath.row == 0
            {
                let cell : fundDetailTitleCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailTitleCell", for: indexPath) as! fundDetailTitleCell
                cell.lblTitle.text = "\(dictrowdata.value(forKey: kHeaderTitleKey)!)"
                cell.btnShow.addTarget(self, action: #selector(self.collapseexpandCell(_:event:)), for: .touchUpInside)
                if dictrowdata.value(forKey: kkeyisExpand) as! Int == 1
                {
                    cell.btnShow.isSelected = true
                    cell.imgBottomView.isHidden = false
                }
                else
                {
                    cell.btnShow.isSelected = false
                    cell.imgBottomView.isHidden = true
                }

                mainCell = cell
            }
            else
            {
                let dicContact : NSDictionary = (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).object(at: indexPath.row-1) as! NSDictionary
                
                let cell : fundDetailDocumentsCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailDocumentsCell", for: indexPath) as! fundDetailDocumentsCell
                cell.lblTitle.text = "\(dicContact.value(forKey: "title")!)"
                cell.lblSubTitle.text = "\(dicContact.value(forKey: "description")!)"
                cell.lblOrganisation.text = "\(dicContact.value(forKey: "category")!)"
                
                if indexPath.row == (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).count
                {
                    let rectShape = CAShapeLayer()
                    rectShape.bounds = cell.vwContentCell.frame
                    rectShape.position = cell.vwContentCell.center
                    rectShape.path = UIBezierPath(roundedRect: cell.vwContentCell.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
                    
                    cell.vwContentCell.layer.backgroundColor = UIColor.white.cgColor
                    cell.vwContentCell.layer.mask = rectShape
                }

                mainCell = cell
            }
        }
        else if indexPath.section == 4
        {
            let dictrowdata : NSDictionary = self.arrMainData[indexPath.section] as! NSDictionary
            if indexPath.row == 0
            {
                let cell : fundDetailTitleCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailTitleCell", for: indexPath) as! fundDetailTitleCell
                cell.lblTitle.text = "\(dictrowdata.value(forKey: kHeaderTitleKey)!)"
                cell.btnShow.addTarget(self, action: #selector(self.collapseexpandCell(_:event:)), for: .touchUpInside)
                if dictrowdata.value(forKey: kkeyisExpand) as! Int == 1
                {
                    cell.btnShow.isSelected = true
                    cell.imgBottomView.isHidden = false
                }
                else
                {
                    cell.btnShow.isSelected = false
                    cell.imgBottomView.isHidden = true
                }

                mainCell = cell
            }
            else
            {
                let dicContact : NSDictionary = (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).object(at: indexPath.row-1) as! NSDictionary
                
                let cell : fundDetailNotesCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailNotesCell", for: indexPath) as! fundDetailNotesCell
                cell.lblDate.text = "\(dicContact.value(forKey: "noteDate")!)"
                cell.lblDescription.text = "\(dicContact.value(forKey: "description")!)"
                cell.lblName.text = "-\(dicContact.value(forKey: "title_by")!)"
                
                if indexPath.row == (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).count
                {
                    let rectShape = CAShapeLayer()
                    rectShape.bounds = cell.vwContentCell.frame
                    rectShape.position = cell.vwContentCell.center
                    rectShape.path = UIBezierPath(roundedRect: cell.vwContentCell.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
                    
                    cell.vwContentCell.layer.backgroundColor = UIColor.white.cgColor
                    cell.vwContentCell.layer.mask = rectShape
                }
                cell.layoutIfNeeded()
                cell.layoutSubviews()
                mainCell = cell
            }
        }
        else if indexPath.section == 5
        {
            let dictrowdata : NSDictionary = self.arrMainData[indexPath.section] as! NSDictionary
            if indexPath.row == 0
            {
                let cell : fundDetailTitleCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailTitleCell", for: indexPath) as! fundDetailTitleCell
                cell.lblTitle.text = "\(dictrowdata.value(forKey: kHeaderTitleKey)!)"
                cell.btnShow.addTarget(self, action: #selector(self.collapseexpandCell(_:event:)), for: .touchUpInside)
                
                if dictrowdata.value(forKey: kkeyisExpand) as! Int == 1
                {
                    cell.btnShow.isSelected = true
                    cell.imgBottomView.isHidden = false
                }
                else
                {
                    cell.btnShow.isSelected = false
                    cell.imgBottomView.isHidden = true
                }

                mainCell = cell
            }
            else
            {
                let dicContact : NSDictionary = (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).object(at: indexPath.row-1) as! NSDictionary
                
                let cell : fundDetailToDoCell = tableView.dequeueReusableCell(withIdentifier: "fundDetailToDoCell", for: indexPath) as! fundDetailToDoCell
                cell.lblDate.text = "\(dicContact.value(forKey: "created")!)"
                cell.lblDescription.text = "\(dicContact.value(forKey: "notes")!)"
                cell.lblName.text = "-\(dicContact.value(forKey: "title")!)"
                
                if indexPath.row == (dictrowdata.value(forKey: kkeyDataKey) as! NSMutableArray).count
                {
                    let rectShape = CAShapeLayer()
                    rectShape.bounds = cell.vwContentCell.frame
                    rectShape.position = cell.vwContentCell.center
                    rectShape.path = UIBezierPath(roundedRect: cell.vwContentCell.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
                    
                    cell.vwContentCell.layer.backgroundColor = UIColor.white.cgColor
                    cell.vwContentCell.layer.mask = rectShape
                }
                else
                {
                    cell.vwContentCell.layoutIfNeeded()
                }
                mainCell = cell
            }
        }
        mainCell.contentView.backgroundColor = UIColor.clear
        mainCell.layer.backgroundColor = UIColor.clear.cgColor
        mainCell.contentView.layoutIfNeeded()
        mainCell.contentView.setNeedsLayout()
        return mainCell
    }

    @IBAction func collapseexpandCell(_ sender: Any, event: Any)
    {
        let touches = (event as AnyObject).allTouches!
        let touch = touches?.first!
        let currentTouchPosition = touch?.location(in: self.tblFinance)
        var indexPath = self.tblFinance.indexPathForRow(at: currentTouchPosition!)!
        
        let dict : NSMutableDictionary = self.arrMainData[indexPath.section] as! NSMutableDictionary
        if dict.value(forKey: kkeyisExpand) as! Int == 1
        {
            dict.setValue(0, forKey: kkeyisExpand)
        }
        else
        {
            dict.setValue(1, forKey: kkeyisExpand)
        }
        self.tblFinance.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - CSPieChartDelegate,CSPieChartDataSource
    func didSelectedPieChartComponent(at index: Int)
    {
        let data = dataList[index]
//        print(data.key)
    }
    func numberOfComponentData() -> Int {
        return dataList.count
    }
    
    func pieChartComponentData(at index: Int) -> CSPieChartData {
        return dataList[index] as! CSPieChartData
    }
    
    func numberOfComponentColors() -> Int {
        return colorList.count
    }
    
    func pieChartComponentColor(at index: Int) -> UIColor {
        return colorList[index] as! UIColor
    }
    
    func numberOfLineColors() -> Int {
        return colorList.count
    }
    
    func pieChartLineColor(at index: Int) -> UIColor {
        return colorList[index] as! UIColor
    }
    
    func numberOfComponentSubViews() -> Int {
        return dataList.count
    }
    
    func pieChartComponentSubView(at index: Int) -> UIView
    {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        let dicContact : NSDictionary = self.arrGraphData[index] as! NSDictionary
        view.text = "\(dicContact.value(forKey: "title")!)"
        view.font = UIFont.systemFont(ofSize: 12.0)
        view.sizeToFit()
        return view
    }
}

//MARK: Cell Defination
class fundDetailCell1 : UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var vwBottom: UIView!
}
class fundDetailTitleCell : UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var imgBottomView: UIImageView!
}
class fundDetailContactCell : UITableViewCell
{
    @IBOutlet weak var vwContentCell : UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
}
class fundDetailDocumentsCell : UITableViewCell
{
    @IBOutlet weak var vwContentCell : UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblOrganisation: UILabel!
}
class fundDetailNotesCell : UITableViewCell
{
    @IBOutlet weak var vwContentCell : UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNameHeightCT: NSLayoutConstraint!
}
class fundDetailToDoCell : UITableViewCell
{
    @IBOutlet weak var vwContentCell : UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblName: UILabel!
}
class fundeDetailPieChart: UITableViewCell
{
    @IBOutlet weak var pieChart: CSPieChart!
}
class fundDetailgraphData: UITableViewCell
{
    @IBOutlet weak var vwContentCell : UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
}
