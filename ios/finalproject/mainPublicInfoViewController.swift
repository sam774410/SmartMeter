//
//  mainPublicInfoViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/9.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit

class mainPublicInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    let log = MYLOG().log
    
    let funcArray = ["最新消息", "過往電力資訊", "電費計算"]
    let iconArray = ["megaphone", "clock", "flash"]
    let descriptionArray = ["➢", "➢", "➢"]
    
    @IBOutlet weak var myTablewView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTablewView.tableFooterView = UIView()
        myTablewView.isScrollEnabled = false
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
        
        if indexPath.row == 0{
            
            let newsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newsVC")
            self.navigationController?.pushViewController(newsVC, animated: true)
        } else if indexPath.row == 1 {
            
            let historyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyVC")
            self.navigationController?.pushViewController(historyVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mainPublicTableViewCell
        
        cell.setUpCell(iconName: iconArray[indexPath.row], funcName: funcArray[indexPath.row], description: descriptionArray[indexPath.row])
        
        return cell
    }

}
