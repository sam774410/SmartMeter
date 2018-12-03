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
    let funcArray = ["關於我們", "版本", "登出"]
    let iconArray = ["about-us", "info", "exit"]
    let descriptionArray = ["➢", "v1.0", ""]
    
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
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mainMoreTableViewCell
        
        cell.setUpCell(iconName: iconArray[indexPath.row], funcName: funcArray[indexPath.row], description: descriptionArray[indexPath.row])
        
        return cell
    }
   
}
