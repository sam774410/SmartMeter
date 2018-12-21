//
//  mainApplyPowerOutViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/24.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import LocalAuthentication
import StepProgressView
import PMSuperButton
import NotificationBannerSwift
import SVProgressHUD
import UIView_Shake
import CDAlertView


class mainApplyPowerOutViewController: UIViewController {

    let log = MYLOG().log
    
    @IBOutlet weak var date_TF: UITextField!
    private var datePicker: UIDatePicker?
    
    var startDate: String?
    
    var currentStep = 0
    //暫停或廢止
    var isSuspendOrStop: Bool?
    var meterID: String?
    var userID: String?
    //isStepView
    var isShowStepView: Bool?
    //復電
    var isRecoveryMeter: Bool?
    
    //apply form
    @IBOutlet weak var applyContainerView: UIView!
    
    //step view cancel btn
    @IBOutlet weak var containerView: UIView!
    
    //back
    @IBAction func cancelApply_Btn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var realCancel_Btn_Outlet: PMSuperButton!
    @IBOutlet weak var cancel_Btn_Outlet: PMSuperButton!
    
    
    @IBOutlet weak var apply_Btn_Outlet: PMSuperButton!
    
    @IBOutlet weak var description_lable: UILabel!
    //cancel apply
    @IBAction func cancel_Btn(_ sender: Any) {
        
        
        
        if let isRecovery = isRecoveryMeter{
            
            if isRecovery {
                
                //取消復電
                let alert = CDAlertView(title: "確定取消？", message: "確定取消申請回復用電？", type: CDAlertViewType.warning)
                let cancelAction = CDAlertViewAction(title: "取消", textColor: .red)
                let okAction = CDAlertViewAction(title: "確定") { (CDAlertViewAction) -> Bool in
                    
                    //handle cancel recovery
                    if let meterID = self.meterID {
                        
                        let parameters = ["meterID": Int(meterID)] as [String: Any]
                        
                        USER_API().user_cancelRecoveryMeter(keys: parameters, completion: { (isSuccess) -> () in
                            
                            if isSuccess {
                                
                                ALERT().banner(tittle: "申請復電已取消", subtitle: "", style: BannerStyle.success)
                            }else {
                                
                                ALERT().banner(tittle: "請稍後再試", subtitle: "", style: BannerStyle.warning)
                            }
                        })
                    }
                    
                self.navigationController?.popViewController(animated: true)
                    return true
                }
                
                alert.add(action: cancelAction)
                alert.add(action: okAction)
                alert.show()
                
            } else {
                //取消申請斷電
                
                let alert = CDAlertView(title: "確定取消？", message: "確定取消申請暫停用電？", type: CDAlertViewType.warning)
                let cancelAction = CDAlertViewAction(title: "取消", textColor: .red)
                let okAction = CDAlertViewAction(title: "確定") { (CDAlertViewAction) -> Bool in
                    
                    //handle cancel action
                    
                    if let meterID = self.meterID {
                        
                        let parameters = ["meterID": Int(meterID)] as [String: Any]
                        
                        USER_API().user_cancelStopMeter(keys: parameters, completion: { (isSuccess) -> () in
                            
                            if isSuccess {
                                
                                ALERT().banner(tittle: "申請斷電已取消", subtitle: "", style: BannerStyle.success)
                            }else {
                                
                                ALERT().banner(tittle: "請稍後再試", subtitle: "", style: BannerStyle.warning)
                            }
                        })
                    }
                    
                    
                    self.navigationController?.popViewController(animated: true)
                    
                    return true
                }
                
                alert.add(action: cancelAction)
                alert.add(action: okAction)
                alert.show()
            }
        }
    }
    
    @IBOutlet weak var stepView: StepProgressView!
    
    //start apply
    @IBAction func apply_Btn(_ sender: Any) {
        
        if let startDate = startDate{
            
            view.endEditing(true)
            self.log.debug("start date： \(startDate)")
            
            if let isRecovery = isRecoveryMeter {
                
                //復電申請
                
                self.log.debug("ready for recovery")
                let alert = CDAlertView(title: "復電申請", message: "起始日為：\(self.startDate!)", type: CDAlertViewType.warning)
                let cancelAction = CDAlertViewAction(title: "取消", textColor: .red)
                let okAction = CDAlertViewAction(title: "確認送出") { (CDAlertViewAction) -> Bool in
                    
                    //do auth
                    self.auththentication(completion: { (isOk) in
                        
                        if isOk {
                            
                            DispatchQueue.main.async {
                                
                                SVProgressHUD.show()
                                self.applyContainerView.isHidden = true
                                self.containerView.isHidden = false
                                
                                let parameters = ["meterID": Int(self.meterID!), "StartDate": startDate, "userID": Int(self.userID!)] as [String: Any]
                                
                                USER_API().user_recoveryMeter(keys: parameters, completion: { (isSuccess) in
                                    
                                    if isSuccess {
                                        
                                        SVProgressHUD.dismiss()
                                        
                                        ALERT().banner(tittle: "申請已送出", subtitle: "我們即將為您審核", style: BannerStyle.success)
                                        
                                        self.stepViewSetUp(curretStep: 1)
                                        //self.meterStatusQuery()
                                    } else {
                                        
                                        SVProgressHUD.dismiss()
                                        
                                        ALERT().banner(tittle: "請稍後再試", subtitle: "", style: BannerStyle.warning)
                                    }
                                })
                            }
                        } else {
                            
                            //can't auth
                            ALERT().banner(tittle: "驗證失敗", subtitle: "請稍後再試", style: BannerStyle.danger)
                        }
                    })
                    
                    return true
                }
                
                alert.add(action: cancelAction)
                alert.add(action: okAction)
                alert.show()
                
            } else {
                
                //斷電申請
                self.log.debug("ready for apply")
                
                let alert = CDAlertView(title: "斷電申請", message: "起始日為：\(self.startDate!)", type: CDAlertViewType.warning)
                let cancelAction = CDAlertViewAction(title: "取消", textColor: .red)
                let okAction = CDAlertViewAction(title: "確認送出", handler: { (CDAlertViewAction) -> Bool in
                    
                    //do auth
                    
                    self.auththentication(completion: { (isOk) in
                        
                        if isOk {
                            
                            // is auth
                            DispatchQueue.main.async {
                                
                                SVProgressHUD.show()
                                
                                self.applyContainerView.isHidden = true
                                self.containerView.isHidden = false
                                
                                if let isSuspendOrStop = self.isSuspendOrStop, let meterID = self.meterID, let userID = self.userID{
                                    
                                    self.log.debug("\(isSuspendOrStop)\(meterID)\(userID)")
                                    
                                    let parameters = ["meterID": Int(meterID), "StartDate": startDate] as [String: Any]
                                    
                                    USER_API().user_stopMeter(keys: parameters, completion: { (isSuccess) in
                                        
                                        if isSuccess {
                                            
                                            SVProgressHUD.dismiss()
                                            
                                            ALERT().banner(tittle: "申請已送出", subtitle: "我們即將為您審核", style: BannerStyle.success)
                                            
                                            self.stepViewSetUp(curretStep: 1)
                                        } else {
                                            
                                            SVProgressHUD.dismiss()
                                            
                                            ALERT().banner(tittle: "請稍後再試", subtitle: "", style: BannerStyle.warning)
                                        }
                                    })
                                }
                            }
                        } else {
                            
                            //can't auth
                            ALERT().banner(tittle: "驗證失敗", subtitle: "請稍後再試", style: BannerStyle.danger)
                        }
                    })
                    return true
                })
                
                alert.add(action: cancelAction)
                alert.add(action: okAction)
                alert.show()
            }
            

        } else {
            
            date_TF.shake()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(mainApplyPowerOutViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mainApplyPowerOutViewController.tapView(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        date_TF.inputView = datePicker
        
        
        stepInit()
        
        if let isSuspendOrStop = isSuspendOrStop , let meterID = meterID {
            
            log.debug(isSuspendOrStop)
            log.debug(meterID)
        }
        
        if let uID = UserDefaults.standard.value(forKey: "id") as? String {
            
            userID = uID
            log.debug("USER AUTO ID： \(userID!)")
        }
        
        //change ui
        if let isRecovery = isRecoveryMeter {
            
            description_lable.text = "復電日期"
            apply_Btn_Outlet.setTitle("申請復電", for: .normal)
            //self.realCancel_Btn_Outlet.isHidden = true
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let isShowStepView = isShowStepView {
            
            if isShowStepView {
                
                //show step
                self.applyContainerView.isHidden = true
                //query step
                meterStatusQuery()
            } else {
                
                //handle apply
                self.containerView.isHidden = true
                
            }
        }
    }
    
    //query meter status
    func meterStatusQuery() {
        
        SVProgressHUD.show()
        
        if let meterID = meterID {
            
            let parameters = ["meterID": meterID] as [String: Any]
            
            USER_API().user_querySuspendStatus(keys: parameters) { (response) in
                
                self.log.warning(response)
                
                if response[1] == "2" {
                    
                    //申請復電
                    
                    self.isRecoveryMeter = true
                    
                    if response[0] == "0" {
                        
                        self.stepViewSetUp(curretStep: 1)
                        //self.realCancel_Btn_Outlet.isHidden = true
                    } else if response[0] == "1" {
                        
                        self.stepViewSetUp(curretStep: 2)
                        self.realCancel_Btn_Outlet.isHidden = true
                    }else if response[0] == "2" {
                        
                        self.stepViewSetUp(curretStep: 4)
                        self.realCancel_Btn_Outlet.isHidden = true
                    }
                } else {
                    
                    //申請斷電
                    self.isRecoveryMeter = false
                    
                    if response[0] == "0" {
                        
                        self.stepViewSetUp(curretStep: 1)
                        
                    } else if response[0] == "1" {
                        
                        self.stepViewSetUp(curretStep: 2)
                        self.realCancel_Btn_Outlet.isHidden = true
                    }else if response[0] == "2" {
                        
                        self.stepViewSetUp(curretStep: 4)
                        self.realCancel_Btn_Outlet.isHidden = true
                    }
                }

                
                
                SVProgressHUD.dismiss()
            }
        }
        
        
    }
    
    @objc func tapView(gestureRecognizer: UITapGestureRecognizer){
        
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "zh_TW")
        
        self.startDate = dateFormatter.string(from: datePicker.date)
        date_TF.text = dateFormatter.string(from: datePicker.date)
        
        self.log.debug("start date： \(self.startDate)")
    }
    
    func stepViewSetUp(curretStep: Int){

        self.stepView.currentStep = curretStep
    }
    
    func stepInit(){
        
        stepView.steps = ["已送出申請", "待審核中", "審核中", "已審核", "申請成功"]
        //stepView.details = [0: "The beginning", 3: "The end"] // appears below step title
        
        stepView.stepShape = .circle
        stepView.firstStepShape = .downTriangle
        stepView.lastStepShape = .triangle
        
        stepView.lineWidth = 2.5
        stepView.verticalPadding = 50 // between steps (0 => default based on textFont)
        stepView.horizontalPadding =  8 // between shape and text (0 => default based on textFont)
        //stepView.currentStep = 0
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
