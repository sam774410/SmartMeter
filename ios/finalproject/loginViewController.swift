//
//  loginViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/21.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import TextFieldEffects
import UIView_Shake
import Alamofire
import SwiftyJSON
import TransitionButton
import Pastel
import PMSuperButton
import NotificationBannerSwift

class loginViewController: UIViewController, UITextFieldDelegate {
    
    //logging
    let log = MYLOG().log
    var infoFromRegisterVC: USER_DATAMODEL?
    var forgetPwdUser: USER_DATAMODEL?
    
    @IBOutlet weak var email_Tf: HoshiTextField!
    
    @IBOutlet weak var password_Tf: HoshiTextField!
    
    @IBOutlet weak var login_Btn_Outlet: TransitionButton!
    
    @IBOutlet weak var register_Btn_Outlet: PMSuperButton!
    
    @IBOutlet weak var fotgot_Btn_Outlet: UIButton!
    @IBAction func register_Btn(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        setUp()
        
        //load data
        if let acct = UserDefaults.standard.value(forKey: "acct") as? String, let pwd = UserDefaults.standard.value(forKey: "pwd") as? String{
            log.info("ACCOUNT:\(acct)")
            log.info("PWD:\(pwd)")
            
            email_Tf.text = acct
            password_Tf.text = pwd
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        setBG()
        
        UIView.animate(withDuration: 0.5) {
            
            self.register_Btn_Outlet.isHidden = false
            self.fotgot_Btn_Outlet.isHidden = false
        }
        
        //拿到註冊成功資料
        if let info = infoFromRegisterVC{
            log.debug(info)
            
            email_Tf.text = info.userAcct
            password_Tf.text = info.userPwd
        }
    }
    
    
    @objc func login() {
        
        if let email = self.email_Tf.text , let pwd = self.password_Tf.text {
            
            if email.count > 1 && pwd.count >= 5 {
                
                login_Btn_Outlet.startAnimation()
                
                let parameters = ["Account": email, "Password": Encoding().base64Encoding(str: pwd)] as [String : Any]
                
                USER_API().user_login(keys: parameters) { (success) in
                    
                    if success {
                        
                        //login success
                        
                        //keep user info
                        UserDefaults.standard.set(email, forKey: "acct")
                        UserDefaults.standard.set(pwd, forKey: "pwd")
                        
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (Timer) in
                            
                            self.register_Btn_Outlet.isHidden = true
                            self.fotgot_Btn_Outlet.isHidden = true
                            
                            self.login_Btn_Outlet.stopAnimation(animationStyle: .expand, revertAfterDelay: 2, completion: {
                                
                                //user default save info
                                
                                let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC")
                                self.present(mainVC, animated: true, completion: nil)
                            })
                        })
                        
                    } else {
                        
                        //login fail
                        self.login_Btn_Outlet.stopAnimation()
                    }
                }
            }else {
                
                self.setTfAlert(textField: self.email_Tf, description: "Account")
                self.setTfAlert(textField: self.password_Tf, description: "Password")
            }

        }else {
            
            self.setTfAlert(textField: self.email_Tf, description: "Account")
            self.setTfAlert(textField: self.password_Tf, description: "Password")
        }
    }
    
    
    
    
    func setloginBtn(loginBtn: TransitionButton){
        
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginBtn.spinnerColor = .white
        loginBtn.cornerRadius = 15
        loginBtn.clipsToBounds = true
    }
    
    func setUp(){
        
        
        email_Tf.delegate = self
        password_Tf.delegate = self
        
        
        setloginBtn(loginBtn: login_Btn_Outlet)
        //圓形邊角
        setBtn(button: register_Btn_Outlet)
        setBtnShadow(button: login_Btn_Outlet)
    }
    
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        email_Tf.resignFirstResponder()
        password_Tf.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    func setBtnShadow(button: UIButton){
        
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 5
        button.layer.masksToBounds = false
    }
    
    func setBtn(button: UIButton){
        
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
    }
    
    
    func setBG (){
        
        let pastelView = PastelView(frame: view.bounds)
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 1.5
        
        // Custom Color
        pastelView.setColors([UIColor(red:0.99, green:0.91, blue:0.64, alpha:1.0),
                              UIColor(red:0.99, green:0.89, blue:0.54, alpha:1.0),
                              UIColor(red:0.98, green:0.87, blue:0.44, alpha:1.0),
                              UIColor(red:0.95, green:0.56, blue:0.51, alpha:1.0),
                              UIColor(red:0.96, green:0.60, blue:0.55, alpha:1.0),
                              UIColor(red:0.96, green:0.64, blue:0.60, alpha:1.0)
                              ])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
    func setTfAlert(textField: HoshiTextField, description: String) {
        
        let tfOrignPlaceHolder: String = textField.placeholder!
        
        textField.placeholderLabel.text = description
        textField.placeholderLabel.textColor = .red
        textField.shake()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
            
            UIView.animate(withDuration: 1) {
                
                textField.placeholderLabel.text = tfOrignPlaceHolder
                textField.placeholderLabel.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            }
        }
    }
    
    //unwing segue
    @IBAction func backToMe(_ segue: UIStoryboardSegue){
        
//        if let registerVC = segue.source as? registerViewController{
//        }
    }
    

    @IBAction func forgetPwd(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "忘記密碼", message: "請輸入帳號", preferredStyle: .alert)
        
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            //print("Text field: \(textField?.text)")
            
            
            if let acct = textField?.text {
                
                if acct.count >= 3{
                    
                    self.log.debug("forget Acct：\(acct)")
                    let parameters = ["Account": acct]
                    USER_API().user_query(keys: parameters, completion: { (userdata) in
                        
                        if userdata != nil {
                            
                            self.log.info(userdata)
                            self.forgetPwdUser?.userAcct = userdata[6]
                            self.forgetPwdUser?.userPwd = Encoding().base64Decoding(encodedStr: userdata[5])
                            self.forgetPwdUser?.userEmail = userdata[2]
                            
                            let parameter = ["Account": userdata[6], "Password": Encoding().base64Decoding(encodedStr: userdata[5]) ,"EmailAddress": userdata[2]]
                            
                            //send pwd
                            USER_API().user_sendPwd(keys: parameter, completion: { (isOk) in
                                
                                if isOk {
                                    
                                    let banner = NotificationBanner(title: "寄送成功", subtitle: "請至註冊信箱查看", style: BannerStyle.success)
                                    banner.show()
                                } else {
                                    
                                    let banner = NotificationBanner(title: "寄送失敗", subtitle: "請至稍後再試", style: BannerStyle.warning)
                                    banner.show()
                                }
                            })
                        }
                    })
                }
               
            }else {
            
            }
           
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    

}
