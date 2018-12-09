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
    @IBOutlet weak var applyContainerView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var stepView: StepProgressView!
    
    @IBAction func apply_Btn(_ sender: Any) {
        
        if let startDate = startDate{
            
            view.endEditing(true)
            self.log.debug("start date： \(startDate)")
            
            let alert = CDAlertView(title: "斷電申請", message: "起始日為：\(self.startDate!)", type: CDAlertViewType.warning)
            let cancelAction = CDAlertViewAction(title: "取消", textColor: .red)
            let okAction = CDAlertViewAction(title: "確認送出", handler: { (CDAlertViewAction) -> Bool in
                
                //do auth
                
                self.auththentication(completion: { (isOk) in
                    
                    if isOk {
                        
                        // is auth
                        
                        DispatchQueue.main.sync {
                            
                            self.applyContainerView.isHidden = true
                            self.containerView.isHidden = false
                            
                            SVProgressHUD.show()
                            
                            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (Timer) in
                                
                               
                                self.stepViewSetUp(curretStep: 1)
                                //write DB
                                self.stepView.details = [0: "\(self.startDate!)"]
                                
                                SVProgressHUD.dismiss()
                            })
                            
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
        self.containerView.isHidden = true
        self.applyContainerView.isHidden = true
        
        initUserApply()
        
    }
    
    func initUserApply() {
        
        self.applyContainerView.isHidden = false
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
        
        stepView.steps = ["已送出申請", "等待審核中", "已審核", "斷電申請成功"]
        //stepView.details = [0: "The beginning", 3: "The end"] // appears below step title
        
        stepView.stepShape = .circle
        stepView.firstStepShape = .downTriangle
        stepView.lastStepShape = .triangle
        
        stepView.lineWidth = 2.5
        stepView.verticalPadding = 50 // between steps (0 => default based on textFont)
        stepView.horizontalPadding =  8 // between shape and text (0 => default based on textFont)

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
