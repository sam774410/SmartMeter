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
import SwiftyBeaver
import TransitionButton
import Pastel
import PMSuperButton


class loginViewController: UIViewController, UITextFieldDelegate {

    //logging
    let log = SwiftyBeaver.self
    
    var infoFromRegisterVC: String?
    
    @IBOutlet weak var email_Tf: HoshiTextField!
    
    @IBOutlet weak var password_Tf: HoshiTextField!
    
    @IBOutlet weak var login_Btn_Outlet: TransitionButton!
    
    @IBOutlet weak var register_Btn_Outlet: PMSuperButton!
    
    @IBAction func register_Btn(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setBG()
        
        if let info = infoFromRegisterVC{
            log.debug(info)
        }
    }
    
    
    @objc func login() {
        
        login_Btn_Outlet.startAnimation()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in
            
            self.login_Btn_Outlet.stopAnimation()
            
            //self.setBtnAlert(textField: self.email_Tf, description: "hi")
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
        
        
        setLogging()
        setloginBtn(loginBtn: login_Btn_Outlet)
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
    
    func setLogging() {
        
        let console = ConsoleDestination()
        let file = FileDestination()  // log to default swiftybeaver.log file
        log.addDestination(console)
        log.addDestination(file)
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
    
    func setBtnAlert(textField: HoshiTextField, description: String) {
        
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
    

    

}
