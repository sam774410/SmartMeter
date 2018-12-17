//
//  newMeterViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/14.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import Eureka
import CDAlertView

class newMeterViewController: FormViewController {

    var isHaveData: Bool = false
    let log = MYLOG().log
    var userID: Int?
    var meterID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let uID = UserDefaults.standard.value(forKey: "id") as? String {
            
            userID = Int(uID)
            log.debug("USER AUTO ID： \(userID!)")
        }
        
        form +++ Section("請輸入電號")
        
        <<< IntRow{ row in
            
            row.title = "電號"
            row.placeholder = "請輸入"
            }.onChange({ (IntRow) in
                
                if let number = IntRow.value {
                    
                    if self.checkIntRow(number: number, numberRow: IntRow) {
                        
                        self.isHaveData = true
                        self.meterID = number
                    } else {
                        
                        self.isHaveData = false
                    }

                }else {
                    
                    self.isHaveData = false
                }
            })
        
        form +++ Section("")
        
        <<< ButtonRow { row in
            
            row.title = "確定"
            }.onCellSelection({ (ButtonCell, ButtonRow) in
                
                if self.isHaveData {
                    
                     // do something
                    
                    let parameters = ["UserID": self.userID!, "ID": self.meterID!]
                    
                
                    USER_API().user_addMeter(keys: parameters, completion: { (isSuccess) in
                        
                        if isSuccess {
                            
                            self.navigationController?.popViewController(animated:  true)
                        }
                    })
                    
                } else {
                    
                    ALERT().alert(title: "錯誤", subTitle: "請確實輸入電號", type: CDAlertViewType.error)
                }
            })
        
        <<< ButtonRow(){ row in
                
            row.title = "取消"
            row.cell.tintColor = .red
            }.onCellSelection({ (cell, ButtonRow) in
                    
                self.navigationController?.popViewController(animated: true)
            })
        
    }
    
    
    func checkIntRow(number: Int, numberRow: IntRow) -> Bool{
        
        if String(number).count < 1 {
            
            numberRow.value = nil
            numberRow.placeholder = "請輸入"
            numberRow.placeholderColor = .red
            return false
        }else {
            
            //ok
            return true
        }
    }

}
