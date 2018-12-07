//
//  mainMoreViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/24.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import CDAlertView

class mainMoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    let log = MYLOG().log
    let funcArray = ["個人資料管理", "密碼變更", "版本", "登出"]
    let iconArray = ["user_update", "key", "round-info-button", "exit"]
    let descriptionArray = ["➢", "➢", CONFIG().app_version, ""]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.tableFooterView = UIView()
        myTableView.isScrollEnabled = false
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return funcArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消選取
        tableView.deselectRow(at: indexPath, animated: true)
        
        if funcArray[indexPath.row] == "登出" {
            
            let alert = CDAlertView(title: "登出", message:"確定要登出嗎?", type: CDAlertViewType.warning)
            let ok = CDAlertViewAction(title: "確定", textColor: .red) { (CDAlertViewAction) -> Bool in
                
                //handler logout success
                ((self.tabBarController?.dismiss(animated: true, completion: nil)) != nil)
            }
            
            let cancel = CDAlertViewAction(title: "取消", textColor: .blue, handler: nil)
            alert.add(action: ok)
            alert.add(action: cancel)
            alert.show()
            
        }else if funcArray[indexPath.row] == "個人資料管理"{
            
            let userUpdateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userUpdateVC")
            
            self.navigationController?.pushViewController(userUpdateVC, animated: true)
            
        }else if funcArray[indexPath.row] == "密碼變更"{
            
            let userPwdUpdateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userPwdUpdateVC")
            
            self.navigationController?.pushViewController(userPwdUpdateVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mainMoreTableViewCell
        
        cell.setUpCell(iconName: iconArray[indexPath.row], funcName: funcArray[indexPath.row], description: descriptionArray[indexPath.row])
        
        return cell
    }
   
    @IBAction func userUpdate(_ segue:UIStoryboardSegue) {
        
    }
}
