//
//  registerViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/21.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Eureka
import SVProgressHUD
import NotificationBannerSwift
import CDAlertView

class registerViewController: FormViewController {
    
    var newUser = USER_DATAMODEL()
    var pwdConfirm = false
    //logging
    let log = MYLOG().log
    
    
    @IBAction func register_Btn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "backTologinVC", sender: nil)
    }
    
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backTologinVC"{
            
            if let loginVC = segue.destination as? loginViewController{
                
                loginVC.infoFromRegisterVC = newUser
            }
        }
    }
    
    
    func setUpView() {
        
        form +++ Section("用戶註冊")
            <<< TextRow{ row in
                
                row.title = "First Name"
                row.placeholder = "請輸入名字"
                }.onChange({ (TextRow) in
                    
                    //optional binding
                    if let firstNameValue = TextRow.value{
                        
                        //check empty
                        if self.checkTextRow(text: firstNameValue, textRow: TextRow) {
                            
                            self.newUser.userFirstName = firstNameValue
                            self.log.info("First Name：\(firstNameValue)")
                        }else {
                            
                            self.newUser.userFirstName = nil
                        }
                    }else{
                        
                        self.newUser.userFirstName = nil
                    }
                    
                }).onCellHighlightChanged({ (TextCell, TextRow) in
                    
                    if let firstNameValue = TextRow.value{
       
                    }else{
                        
                        TextRow.placeholderColor = .red
                        self.newUser.userFirstName = nil
                    }
                })
            
            <<< TextRow{ row in
                
                row.title = "Last Name"
                row.placeholder = "請輸入姓"
                }.onChange({ (TextRow) in
                    
                    if let lastNameValue = TextRow.value {
                        
                        if self.checkTextRow(text: lastNameValue, textRow: TextRow) {
                            
                            self.newUser.userLastName = lastNameValue
                            self.log.info("Last Name：\(lastNameValue)")
                        }else {
                            
                            self.newUser.userLastName = nil
                        }
                    }else {
                        
                        self.newUser.userLastName = nil
                    }
                }).onCellHighlightChanged({ (TextCell, TextRow) in
                    
                    if let lastNameValue = TextRow.value {
                        
                    }else {
                        
                        TextRow.placeholderColor = .red
                        self.newUser.userLastName = nil
                    }
                })
            
            <<< TextRow{ row in
                
                row.title = "身分證字號"
                row.placeholder = "請輸入身分證字號"
                }.onChange({ (TextRow) in
                    
                    if let idValue = TextRow.value {
                        
                        if self.checkTextRow(text: idValue, textRow: TextRow) {
                            
                            self.newUser.userID = idValue
                            self.log.info("ID：\(idValue)")
                        }
                    }else {
                        
                        self.newUser.userID = nil
                    }
                }).onCellHighlightChanged({ (TextCell, TextRow) in
                    
                    if let idValue = TextRow.value {
                        
                    }else {
                        
                        TextRow.placeholderColor = .red
                        self.newUser.userID = nil
                    }
                })
            
            <<< TextRow{ row in
                
                row.title = "帳號"
                row.placeholder = "請輸入帳號"
                }.onChange({ (TextRow) in
                    
                    if let acctValue = TextRow.value {
                        
                        if self.checkTextRow(text: acctValue, textRow: TextRow) {
                            
                            self.newUser.userAcct = acctValue
                            self.log.info("帳號：\(acctValue)")
                        }else {
                            
                            self.newUser.userAcct = nil
                        }
                    }else {
                        
                        self.newUser.userAcct = nil
                    }
                    
                }).onCellHighlightChanged({ (TextCell, TextRow) in
                    
                    if let acctValue = TextRow.value {
                        
                    }else {
                        
                        TextRow.placeholderColor = .red
                        self.newUser.userAcct = nil
                    }
                })
            
            <<< PasswordRow(){
                
                $0.title = "密碼"
                $0.placeholder = "請輸入密碼"
                }.onChange({ (PasswordRow) in
                    
                    if let pwdValue = PasswordRow.value {
                        
                        if self.checkPwdRow(pwd: pwdValue, pwdRow: PasswordRow){
                            
                            self.newUser.userPwd = pwdValue
                            self.log.info("密碼：\(pwdValue)")
                        }else {
                            
                            self.newUser.userPwd = nil
                        }
                    }else {
                        self.newUser.userPwd = nil
                    }
                }).onCellHighlightChanged({ (PasswordCell, PasswordRow) in
                    
                    if let pwdValue = PasswordRow.value {
                        
                    }else {
                        
                        PasswordRow.placeholderColor = .red
                        self.newUser.userPwd = nil
                    }
                })
            //pwd confirm
            <<< PasswordRow() {
                    $0.title = "密碼確認"
                    $0.placeholder = "請再次輸入密碼"
                }.onChange({ (PasswordRow) in
                    
                    if let pwdValue = PasswordRow.value {
                        
                        if let userPwd = self.newUser.userPwd {
                            
                            if pwdValue == userPwd {
                                
                                self.pwdConfirm = true
                            }else {
                                
                                self.pwdConfirm = false
                                PasswordRow.placeholder = "請再次確認密碼"
                                PasswordRow.placeholderColor = .red
                                PasswordRow.value = ""
                            }
                        }else {
                            
                            self.pwdConfirm = false
                        }
                    }else {
                        
                        self.pwdConfirm = false
                    }
                    
                }).onCellSelection({ (PasswordCell, PasswordRow) in
                    
                    if let pwdValue = PasswordRow.value {
                        
                    }else {
                        
                        PasswordRow.placeholderColor = .red
                        self.pwdConfirm = false
                    }
                })
            <<< EmailRow{ row in
                
                row.title = "連絡信箱"
                row.placeholder = "請輸入電子信箱"
                }.onChange({ (EmailRow) in
                    
                    if let emailValue = EmailRow.value {
                        
                        if self.checkEmailRow(text: emailValue, emailRow: EmailRow){
                            
                            self.newUser.userEmail = emailValue
                            self.log.info("電郵：\(emailValue)")
                        }else {
                            
                             self.newUser.userEmail = nil
                        }
                    }else {
                        
                        self.newUser.userEmail = nil
                    }
                }).onCellHighlightChanged({ (EmailCell, EmailRow) in
                    
                    if let emailValue = EmailRow.value {
                        
                    }else {
                        
                        EmailRow.placeholderColor = .red
                        self.newUser.userEmail = nil
                    }
                })
            
            <<< PhoneRow(){
                
                $0.title = "聯絡電話"
                $0.placeholder = "手機/電話號碼"
                }.onChange({ (PhoneRow) in
                    
                    if let phoneValue = PhoneRow.value {
                        
                        if self.checkPhoneRow(text: phoneValue, phoneRow: PhoneRow){
                            
                            self.newUser.userContactPhone = phoneValue
                            self.log.info("聯絡電話：\(phoneValue)")
                        }else {
                            
                            self.newUser.userContactPhone = nil
                        }
                    }else {
                        
                        self.newUser.userContactPhone = nil
                    }
                }).onCellHighlightChanged({ (PhoneCell, PhoneRow) in
                    
                    if let phoneValue = PhoneRow.value{
                        
                    }else {
                        
                        PhoneRow.placeholderColor = .red
                        self.newUser.userContactPhone = nil
                    }
                })
            
            <<< TextRow(){
                
                $0.title = "地址"
                $0.placeholder = "請輸入地址"
                }.onChange({ (TextRow) in
                    
                    if let addressValue = TextRow.value {
                        
                        if self.checkTextRow(text: addressValue, textRow: TextRow) {
                            
                            self.newUser.userAddress = addressValue
                            self.log.info("地址：\(addressValue)")
                        }else {
                            
                            self.newUser.userAddress = nil
                        }
                    }else {
                        
                        self.newUser.userAddress = nil
                    }
                }).onCellHighlightChanged({ (TextCell, TextRow) in
                    
                    if let addressValue = TextRow.value {
                        
                    }else {
                        
                        TextRow.placeholderColor = .red
                        self.newUser.userAddress = nil
                    }
                })
           
            +++ Section()
            <<< ButtonRow(){
                
                $0.title = "註冊"
                }.onCellSelection({ (cell, ButtonRow) in
                    
                    //register and final check
                    self.register(user: self.newUser)
                })
            <<< ButtonRow(){
                
                $0.title = "取消"
                $0.cell.tintColor = .red
                }.onCellSelection({ (cell, ButtonRow) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
    }
    
    func checkPwdRow(pwd: String, pwdRow: PasswordRow) -> Bool{
        
        if pwd.count < 5 {
            
            pwdRow.value = ""
            pwdRow.placeholder = "密碼需大於五個字元"
            pwdRow.placeholderColor = .red
            return false
        }else {
            
            //ok
            return true
        }
    }
    
    func checkTextRow(text: String, textRow: TextRow) -> Bool {
        
        if text.count < 1 {
            
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
    
    func register(user:USER_DATAMODEL) {
        
        
        self.log.debug(pwdConfirm)
        
        if let first = user.userFirstName, let last = user.userLastName, let id = user.userID,
            let acct = user.userAcct, let pwd = user.userPwd, let email = user.userEmail,
            let contact = user.userContactPhone, let address = user.userAddress{
            
            self.log.debug(user)
            
            if pwdConfirm {
                
                //register (ped encoding)
                let parameters = ["Account": acct, "Password": Encoding().base64Encoding(str: pwd), "EmailAddress": email, "ContactPhoneNum": contact, "ContactAddress": address, "FirstName": first, "LastName": last, "IdentityNum": id] as [String : Any]
                
                self.log.debug(parameters)
                
                USER_API().user_register(keys: parameters) { (ok)  in
                    
                    if ok {
                        
                        self.log.debug("success")
                        self.performSegue(withIdentifier: "backTologinVC", sender: nil)
                    } else {
                        
                        self.log.debug("fail")
                    }
                }
            }
        } else {
            
            let alert = CDAlertView(title: "警告", message: "請確實輸入資料", type: CDAlertViewType.error)
            let okAction = CDAlertViewAction(title: "確認")
            alert.add(action: okAction)
            alert.show()
        }
//        let banner = NotificationBanner(title: "註冊成功", style: .success)
//        banner.show()
    }

}
