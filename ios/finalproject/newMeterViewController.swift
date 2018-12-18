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
    
    var chargeTitle: [String] = ["非時間電價-非營業性質", "非時間電價-營業性質", "時間電價 二段式", "時間電價 三段式"]
    var chargeType: Int = 1
    
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
        
        form +++ SelectableSection<ListCheckRow<String>>("請選擇收費模式", selectionType: .singleSelection(enableDeselection: true))
        
        <<< ActionSheetRow<String>() {
            
                $0.title = "收費模式"
                $0.selectorTitle = "請選擇收費模式"
                $0.options = chargeTitle
                $0.value = chargeTitle[0]    // initially selected
            }.onChange({ (ActionSheetRow) in
                
                if ActionSheetRow.value! == self.chargeTitle[0] {
                    
                    self.chargeType = 1
                } else if ActionSheetRow.value! == self.chargeTitle[1] {
                    
                    self.chargeType = 2
                } else if ActionSheetRow.value! == self.chargeTitle[2] {
                    
                    self.chargeType = 3
                } else if ActionSheetRow.value! == self.chargeTitle[3] {
                    
                    self.chargeType = 4
                }
                
                self.log.debug("current charge type：\(ActionSheetRow.value!) \(self.chargeType)")
            })
        
        form +++ Section("")
        
        <<< ButtonRow { row in
            
            row.title = "確定"
            }.onCellSelection({ (ButtonCell, ButtonRow) in
                
                if self.isHaveData {
                    
                    // do something

                    //UserID : user auto id , ID: meter id
                    let parameters = ["UserID": self.userID!, "ID": self.meterID!, "ChargeType": self.chargeType] 
                    
                
                    USER_API().user_addMeter(keys: parameters, completion: { (isSuccess) in
                        
                        if isSuccess {
                            
                            USER_API().user_addContract(keys: parameters, completion: { (isSuccess) in
                                
                                
                            })
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
