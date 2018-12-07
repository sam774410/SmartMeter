//
//  applyProgressViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/7.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import Eureka
import LocalAuthentication
import CDAlertView

class applyProgressViewController: FormViewController {

    let log = MYLOG().log
    var startDate: String = "2018-12-7"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
       
        form +++ Section("斷電申請")
            
        <<< DateRow(){
            $0.title = "起始日期"
            $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }.onChange({ (DateRow) in
                    
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "zh_TW")
                print(dateFormatter.string(from: DateRow.value!))
                
                //let dateString = dateFormatter.string(from: DateRow.value!)
                self.startDate = dateFormatter.string(from: DateRow.value!)
                
                self.log.debug("start date： \(self.startDate)")
                
                
            }).cellUpdate({ (DateCell, DateRow) in
                
                //起始今天
                DateCell.datePicker.minimumDate = Date()
            })
        
        form +++ Section()
        
        <<< ButtonRow { row in
            
            row.title = "申請"
            }.onCellSelection({ (cell, ButtonRow) in
                
                //self.tableView.isHidden = true
                
                let alert = CDAlertView(title: "斷電申請", message: "起始日為：\(self.startDate)", type: CDAlertViewType.warning)
                let cancelAction = CDAlertViewAction(title: "取消", textColor: .red)
                let okAction = CDAlertViewAction(title: "確認送出", handler: { (CDAlertViewAction) -> Bool in
                    
                    //do auth
                    
                    self.auththentication(completion: { (isOk) in
                        
                        if isOk {
                            
                            // is auth
                            
                            DispatchQueue.main.async {
                                
                                //self.tableView.isHidden = true
                            }
                        } else {
                            
                            //can't auth
                            
                        }
                    })
                    return true
                })
                
                alert.add(action: cancelAction)
                alert.add(action: okAction)
                alert.show()
            })
    }
    

    func auththentication(completion: @escaping(Bool) -> ()) {
        
        let context = LAContext()
        var error: NSError?
        let description: String = "驗證起來！"
        var isSuccess = false
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) { (success, error) in
                
                if (success) {
                    
                    self.log.info("user斷電驗證成功")
                    
                    isSuccess = true
                    completion(isSuccess)
                
                } else {
                    
                    self.log.info("user斷電驗證失敗")
                    
                    isSuccess = false
                    completion(isSuccess)
                }
            }
        } else {
            
            let errorDescription = error?.userInfo["NSLocalizedDescription"] ?? ""
            print(errorDescription) // Biometry is not available on this device.
        }
    }

}
