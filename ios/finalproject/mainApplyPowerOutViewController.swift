//
//  mainApplyPowerOutViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/24.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import LocalAuthentication

class mainApplyPowerOutViewController: UIViewController {

    let log = MYLOG().log
    var isAuthentication: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auththentication()
    }
    

    func auththentication() {
        
        let context = LAContext()
        var error: NSError?
        let description: String = "驗證起來！"
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) { (success, error) in
                
                if (success) {
                    
                    self.log.info("user斷電驗證成功")
                    
                    self.isAuthentication = true
                } else {
                    
                    self.log.info("user斷電驗證失敗")
                    
                    self.isAuthentication = false
                }
            }
        } else {
            
            let errorDescription = error?.userInfo["NSLocalizedDescription"] ?? ""
            print(errorDescription) // Biometry is not available on this device.
        }
    }
    

}
