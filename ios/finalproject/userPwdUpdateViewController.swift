//
//  userPwdUpdateViewController.swift
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

class userPwdUpdateViewController: FormViewController {
    
    var user = USER_DATAMODEL()
    var isPwdChanged: Bool = false
    var oldPwdIsOk: Bool = false
    
    //logging
    let log = MYLOG().log
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            
            SVProgressHUD.show()
            // load user info
            if let acct = UserDefaults.standard.value(forKey: "acct") as? String{
                self.log.info("ACCOUNT:\(acct)")
                
                self.user.userAcct = acct
                
                let parameters = ["Account": self.user.userAcct!] as [String: Any]
                USER_API().user_query(keys: parameters) { (userdata) in
                    
                    self.log.info(userdata)
                    
                    self.user.userPwd = userdata[5]
                    
                    self.log.info(self.user.userPwd)
                    self.setUp(user: self.user)
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    
    func setUp(user: USER_DATAMODEL) {
        
        form +++ Section("密碼變更")
            <<< PasswordRow{ row in
                
                row.title = "舊密碼"
                row.placeholder = "請輸入舊密碼"
                }.onChange({ (PasswordRow) in
                    
                    
                }).onCellHighlightChanged({ (PasswordCell, PasswordRow) in
                    
                    if let text = PasswordRow.value {

                        if Encoding().base64Decoding(encodedStr: self.user.userPwd!) != text {
                                                        
                            //pwd no match
                            PasswordRow.value = ""
                            PasswordRow.placeholder = "請輸入正確密碼"
                            PasswordRow.placeholderColor = .red
                            self.oldPwdIsOk = false
                        }else {
                            
                            //match
                            self.oldPwdIsOk = true
                        }
                    } else {
                        
                        self.oldPwdIsOk = false
                    }

                })
        
            <<< PasswordRow{ row in
                
                row.title = "新密碼"
                row.placeholder = "請輸入新密碼"
                }.onChange({ (PasswordRow) in
                    
                    if let text = PasswordRow.value {
                        
                        if self.checkPwdRow(pwd: text, pwdRow: PasswordRow){
                            
                            self.user.userPwd = text
                            //self.isPwdChanged = true
                            self.log.debug("new pwd :" + self.user.userPwd!)
                        }else{
                            
                            self.isPwdChanged = false
                        }
                    }else{
                        
                        self.isPwdChanged = false
                    }
                    
                }).onCellHighlightChanged({ (PasswordCell, PasswordRow) in
                    
                    if let text = PasswordRow.value {
                        
                        if self.checkPwdRow(pwd: text, pwdRow: PasswordRow){
                            
                            self.user.userPwd = text
                            //self.isPwdChanged = true
                            
                        }else{
                            
                            self.isPwdChanged = false
                        }
                    }else{
                        
                        self.isPwdChanged = false
                    }
                })
        
            <<< PasswordRow{ row in
                
                row.title = "密碼確認"
                row.placeholder = "請再次輸入新密碼"
                }.onChange({ (PasswordRow) in
                    
                    
                    
                }).onCellHighlightChanged({ (PasswordCell, PasswordRow) in
                    
                    if let text = PasswordRow.value {
                        
                        if text != self.user.userPwd {
                            
                            //confirm fail
                            self.isPwdChanged = false
                            PasswordRow.value = ""
                            PasswordRow.placeholderColor = .red
                            PasswordRow.placeholder = "請再次確認密碼"
                        } else {
                            
                            //comfirm ok
                            self.isPwdChanged = true
                        }
                        
                    } else {
                        
                        self.isPwdChanged = false
                    }
                })
        
        form +++ Section()
            <<< ButtonRow(){
                
                $0.title = "確認修改"
                }.onCellSelection({ (cell, ButtonRow) in
                    
                    //update
                    if self.isPwdChanged && self.oldPwdIsOk {
                        
                        let alert = CDAlertView(title: "確定更新密碼？", message: "", type: CDAlertViewType.warning)
                        let cancelAction = CDAlertViewAction(title: "取消", textColor: .red)
                        let okAction = CDAlertViewAction(title: "確定", handler: { (CDAlertViewAction) -> Bool in
                            
                            DispatchQueue.main.async {
                                
                                let parameters = ["Account": self.user.userAcct!, "Password": Encoding().base64Encoding(str: self.user.userPwd!)] as [String: Any]

                                USER_API().user_updatePwd(keys: parameters, completion: { (isOk) in
                                    
                                    if isOk {
                                        
                                        let banner = NotificationBanner(title: "密碼更新成功", style: .success)
                                        banner.show()
                                        
                                        //keep user info
                                        UserDefaults.standard.set(self.user.userPwd!, forKey: "pwd")
                                        self.navigationController?.popViewController(animated: true)
                                        
                                    } else {
                                        
                                        let banner = NotificationBanner(title: "請稍後再試", style: BannerStyle.warning)
                                        banner.show()
                                    }
                                })
                            }
                            return true
                        })
                        alert.add(action: cancelAction)
                        alert.add(action: okAction)
                        alert.show()
                        
                    } else {
                        
                        ALERT().alert(title: "錯誤", subTitle: "請確實輸入資料", type: CDAlertViewType.error)
                    }
                   
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


}
