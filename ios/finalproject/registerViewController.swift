//
//  registerViewController.swift
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

class registerViewController: UIViewController {

    //logging
    let log = SwiftyBeaver.self
    
    
    @IBAction func register_Btn(_ sender: UIButton) {
        
        performSegue(withIdentifier: "backTologinVC", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backTologinVC"{
            
            if let loginVC = segue.destination as? loginViewController{
                
                //loginVC.infoFromRegisterVC = "hi"
            }
        }
    }
    
    //logging
    func setLogging() {
        
        let console = ConsoleDestination()
        let file = FileDestination()  // log to default swiftybeaver.log file
        log.addDestination(console)
        log.addDestination(file)
    }
}
