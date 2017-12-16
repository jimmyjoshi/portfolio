//
//  Constant.swift
//  YoBored_New
//
//  Created by Bhavik on 18/07/16.
//  Copyright © 2016 Bhavik. All rights reserved.
//

import Foundation
import UIKit

let MainScreen = UIScreen.main.bounds.size

let appDelegate     = UIApplication.shared.delegate as! AppDelegate
let userDefaults    = UserDefaults.standard
let Application_Name  =  "Bonfire"
let Alert_NoInternet    = "You are not connected to internet.\nPlease check your internet connection."
let kPrivacyTermsVCViewID = "PrivacyTermsVC"
let Alert_NoDataFound    = "No Data Found."

let kkeydata = "data"
let kkeymessage = "message"
let kkeyuserid = "id"
let kkeyuser_name = "user_name"
let kkeyemail = "email"
let kkeybio = "bio"
let kkeydevice_id = "device_id"
let kkeyimage = "image"
let kkeystatus = "status"
let kkeyvisibility = "visibility"
let kkeyname = "name"
let kkeyaddress = "address"
let kkeyfirst_name = "first_name"
let kkeylast_name = "last_name"
let kkeyfollowing = "following"
let kkeylat = "lat"
let kkeylon = "lon"
let kkeyuser = "user"
let kkeyLoginData = "LoginData"
let kkeyAllCampusUser = "AllCampusUser"

let kkeyisMember = "isMember"
let kkeyisLeader = "isLeader"
let kkeyisPrivate = "isPrivate"
let kkeymemberStatus = "memberStatus"
let kkeyis_attachment = "is_attachment"
let kkeyattachment_link = "attachment_link"

let kkeyisUserLogin = "UserLogin"
let kkeyError = "error"
let kkeyCampusCode = "CampusCode"
let kkeyCampusID = "campusID"

let kkeytext = "text"
let kkeytime = "time"
let kkeytitle = "title"

let kNO = "NO"
let kYES = "YES"

let kFBAPPID = "128398547683260"


let kServerURL = "http://52.66.73.127/port-folio/public/api/"

let kforgotpassword = "forgotpassword"
let kLogin = "login"
let kgetContacts = "get-contacts"
let kgetAllEntities = "get-all-entities"
let kgetTeamMembers = "get-team-members"

let kUserprofile = "user-profile-with-interest/"



let kEditProfileAPI = "user-profile/update-profile"

let kReportFeed = "feeds/report"
let kReportUser = "users/report-user"

let kPrivacy = "privacy-policy"
let kTermsConditions = "terms-conditions"

//var CurrentUser : UserModel = UserModel()

let kIdentifire_AddInterestToMsgView = "AddInterestToMsgView"
let kIdentifire_GroupTitleVC = "GroupTitleVC"

var progressView : UIView?

//var CurrentUser : ModelUser = ModelUser()
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: self)
    }
}
//MARK:- Dashboard Constants
var kNewsTitleKey = "Title"
var kNewsDescriptionKey = "Description"
var kNewsDateKey = "Date"

var kNewsCollCellIdentifier = "collNews"

//MARK:- Entity Screen Constants
var kTitleKey = "Title"
var kDescriptionKey = "Description"
var kEntityCellIdentifier = "entityCell1"

//MARK:- Entity Detail Screen Constants
var kEntityDetailHeaderCellIdentifier = "headerCell"
var kEntityDetailCompanyCellIdentifier = "companyDetailCell"
var kEntityDetailCompanyTitleNameKey = "Title"
var kEntityDetailCompanyNameKey = "Name"
var kEntityDetailCompanyAmountKey = "Amount"
var kEntityDetailCompanyPerKey = "Percent"
var kEntityDetailCompanyArrKey = "CompanyArray"

//MARK:- News Screen Constants
var kNewsCellIdentifier = "newsCell"
var kDateKey = "Date"

//MARK:- Contact Screen Constants
var kContactsCellIdentifier = "contactCell"
var kNameKey = "Name"
var kPostKey = "Post"
var kImageKey = "Image"
var kCompanyNameKey = "CompanyName"


//MARK:- Document Screen Constants
var kDocumentCellIdentifier = "documentCell"

//MARK:- Team Screen Constants
var kTeamCellIdentifier = "teamCell"
var kTeamNameKey = "Name"
var kTeamDescriptionKey = "Description"
var kTeamStarKey = "Star"
var kTeamImageKey = "Image"

//MARK:- Team Detail Screen Constants
var kTeamMemberCellIdentifier = "teamMemberCell"
var kTeamMemberNameKey = "Name"
var kTeamMemberImageKey = "Image"
var kTeamMemberPostKey = "Post"
var kTeamMemberContactNoKey = "PhoneNo"

//MARK:- Company Screen Constants
var kCompanyNamKey = "Name"
var kCompanyAmountKey = "Amount"
var kCompanyPercentKey = "Percent"
var kCompanyCellIdentifier = "companyCell"
var kCompanyHeaderIdentifier = "headerCell"

//Mark:- Financial Summary Constants
var kHeaderTitleKey = "Title"
var kFinancialCompanyNameKey = "Name"
var kFinancialCompanyDescKey = "Desc"
var kFinancialDetailArrKey = "DetailArray"
var kFinancialHeaderCellIdentifier = "financialHeaderCell"
var kFinancialDetailIdentifier = "financialDetailCell"
var kFinancialCompanyAmountKey = "Amount"
var kFinancialCashMainCellIdentifier = "cashMainCell"
var kFinancialCashDetailCellIdentifier = "cashDetailCell"


