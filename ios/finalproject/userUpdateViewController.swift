//
//  userUpdateViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/5.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Eureka
import SVProgressHUD
import NotificationBannerSwift
import CDAlertView

class userUpdateViewController: FormViewController {

    var user = USER_DATAMODEL()
    
    //update or not
    var isUpdate = false
    //logging
    let log = MYLOG().log
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         SVProgressHUD.show()
        // load user info
        if let acct = UserDefaults.standard.value(forKey: "acct") as? String{
            log.info("ACCOUNT:\(acct)")
        
            self.user.userAcct = acct

            let parameters = ["Account": user.userAcct!] as [String: Any]
            USER_API().user_query(keys: parameters) { (userdata) in
                
                self.log.info(userdata)
                
                self.user.userFirstName = userdata[0]
                self.user.userLastName = userdata[1]
                self.user.userEmail = userdata[2]
                self.user.userContactPhone = userdata[3]
                self.user.userAddress = userdata[4]

                
                self.setUp(user: self.user)
                SVProgressHUD.dismiss()
            }
        }
        
        
    }
    
    func setUp(user:USER_DATAMODEL){
        
        form +++ Section("修改個人資料")
            <<< TextRow{ row in
                
                row.title = "First Name"
                row.value = user.userFirstName
                row.placeholder = "請輸入名字"
                
                }.onChange({ (TextRow) in
                    
                    if let text = TextRow.value {
                        
                        if self.checkTextRow(text: text, textRow: TextRow) {
                            
                            self.log.info("first name :\(text)")
                            self.user.userFirstName = text
                            self.isUpdate = true
                        }else {
                            
                            self.user.userFirstName = nil
                        }
                    }else {
                        
                        self.user.userFirstName = nil
                    }
                    
                }).cellSetup({ (TextCell, TextRow) in
                    
                    self.user.userFirstName = TextRow.value
                })
        
            <<< TextRow{row in
                
                row.title = "Last Name"
                row.value = user.userLastName
                row.placeholder = "請輸入姓"
                
                }.onChange({ (TextRow) in
                    
                    if let text = TextRow.value {
                        
                        if self.checkTextRow(text: text, textRow: TextRow) {
                            
                            self.log.info("last name :\(text)")
                            self.user.userLastName = text
                            self.isUpdate = true
                        }else {
                            
                            self.user.userLastName = nil
                        }
                    }else {
                        
                        self.user.userLastName = nil
                    }
                    
                }).cellSetup({ (TextCell, TextRow) in
                    
                    self.user.userLastName = TextRow.value
                })
        
            <<< EmailRow{ row in
                
                row.title = "連絡信箱"
                row.placeholder = "請輸入電子信箱"
                row.value = user.userEmail
               
                }.onChange({ (EmailRow) in
                    
                    if let text = EmailRow.value {
                        
                        if self.checkEmailRow(text: text, emailRow: EmailRow) {
                            
                            self.log.info("email  :\(text)")
                            self.user.userEmail = text
                            self.isUpdate = true
                        }else {
                            
                            self.user.userEmail = nil
                        }
                    }else {
                        
                        self.user.userEmail = nil
                    }
                    
                }).cellSetup({ (EmailCell, EmailRow) in
                    
                    self.user.userEmail = EmailRow.value
                })
        
            <<< PhoneRow{ row in
                
                row.title = "連絡電話"
                row.placeholder = "請輸入手機/電話"
                row.value = user.userContactPhone
               
                }.onChange({ (PhoneRow) in
                    
                    if let text = PhoneRow.value {
                        
                        if self.checkPhoneRow(text: text, phoneRow: PhoneRow) {
                            
                            self.log.info("phone :\(text)")
                            self.user.userContactPhone = text
                            self.isUpdate = true
                        }
                    }else {
                        
                        self.user.userContactPhone = nil
                    }
                }).cellSetup({ (PhoneCell, PhoneRow) in
                    
                    self.user.userContactPhone = PhoneRow.value
                })
        
            <<< TextRow{ row in
                
                row.title = "地址"
                row.placeholder = "請輸入地址"
                row.value = user.userAddress
                
                }.onChange({ (TextRow) in
                    
                    if let text = TextRow.value {
                        
                        if self.checkTextRow(text: text, textRow: TextRow) {
                            
                            self.log.info("address :\(text)")
                            self.user.userAddress = text
                            self.isUpdate = true
                        }else {
                            
                            self.user.userAddress = nil
                        }
                    }else {
                        
                        self.user.userAddress = nil
                    }
                    
                }).cellSetup({ (TextCell, TextRow) in
                    
                    self.user.userAddress = TextRow.value
                })
        
        form +++ Section()
            <<< ButtonRow(){
                
                $0.title = "確認修改"
                }.onCellSelection({ (cell, ButtonRow) in
                    
                    //update
                    
                    if self.isUpdate {
                        
                        if let first = self.user.userFirstName, let last = self.user.userLastName, let email = self.user.userEmail, let phone = self.user.userContactPhone, let address = self.user.userAddress {
                            
                            let alert = CDAlertView(title: "確定更新個人資料？", message: "", type: CDAlertViewType.warning)
                            let cancelAction = CDAlertViewAction(title: "取消", textColor: .red)
                            let okAction = CDAlertViewAction(title: "確定", handler: { (CDAlertViewAction) -> Bool in
                                
                                    let parameters = ["FirstName": first, "LastName": last, "EmailAddress": email, "ContactPhoneNum": phone, "ContactAddress": address, "Account": user.userAcct!]
                                
                                    self.log.warning(parameters)
                                
                                    USER_API().user_updateInfo(keys: parameters, completion: { (isOk) in

                                        if isOk {

                                            let banner = NotificationBanner(title: "資料更新成功", style: .success)
                                            banner.show()
                                            self.navigationController?.popViewController(animated: true)
                                        }else{

                                            let banner = NotificationBanner(title: "請稍後再試", style: BannerStyle.warning)
                                            banner.show()
                                        }
                                    })
                                    return true
                            })
                            alert.add(action: cancelAction)
                            alert.add(action: okAction)
                            alert.show()


                            
                        } else {
                            
                            ALERT().alert(title: "警告", subTitle: "請確實輸入資料", type: CDAlertViewType.error)
                        }
                    }else {
                        
                        //no update
                        ALERT().alert(title: "與舊資料相符", subTitle: "此次無異動", type: CDAlertViewType.warning)
                    }
                })
            
            <<< ButtonRow(){
                
                $0.title = "取消"
                $0.cell.tintColor = .red
                }.onCellSelection({ (cell, ButtonRow) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
    }
    
    func checkTextRow(text: String, textRow: TextRow) -> Bool {
        
        if text.count <= 1 {
            
            textRow.value = ""
            //textRow.placeholder = "不可為空"
            textRow.placeholderColor = .red
            return false
        }else {
            
            return true
        }
    }
    
    func checkEmailRow(text: String, emailRow: EmailRow) -> Bool {
        
        if text.count < 5 {
            
            emailRow.value = ""
            emailRow.placeholderColor = .red
            return false
        }else if !text.contains("@") {
            
            emailRow.value = ""
            emailRow.placeholder = "請輸入有效Email"
            emailRow.placeholderColor = .red
            return false
        }
        else {
            
            return true
        }
    }
    
    func checkPhoneRow(text: String, phoneRow: PhoneRow) -> Bool {
        
        if text.count < 5 {
            
            phoneRow.value = ""
            phoneRow.placeholderColor = .red
            return false
        } else {
            
            return true
        }
    }
    
    

}
