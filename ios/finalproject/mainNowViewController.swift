//
//  mainNowViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/24.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD
import CDAlertView
import PullToRefresh

class mainNowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return monthFeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row > monthFeeArray.count-1){
            return UITableViewCell()
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mainNowTableViewCell
            
            cell.setUpCell(iconName: "milometer", meterID: monthFeeArray[indexPath.row].MeterID!, usage: monthFeeArray[indexPath.row].MonthUsage!, fee: monthFeeArray[indexPath.row].MonthFee!)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    let log = MYLOG().log
    var userID: Int?
    var monthFeeArray = [MONTH_FEE]()
    var overlay : UIView?
    
    @IBOutlet weak var total_usage_label: UILabel!
    @IBOutlet weak var total_fee_label: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    var totalUsage: Double = 0.0
    var totalFee: Double = 0.0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.tableFooterView = UIView()
        
        let refresher = PullToRefresh()
        myTableView.addPullToRefresh(refresher) {

            self.monthFeeArray = [MONTH_FEE]()
            self.totalUsage = 0.0
            self.totalFee = 0.0
            self.get_userMonthFee()
            self.myTableView.endAllRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //start query fee
        if let acct = UserDefaults.standard.value(forKey: "acct") as? String{
            log.info("ACCOUNT:\(acct)")
            
            let parameters = ["Account": acct] as [String: Any]
            USER_API().user_query(keys: parameters) { (userdata) in
                
                self.log.info(userdata)
                
                UserDefaults.standard.set(userdata[7], forKey: "id")
                
                if let uID = UserDefaults.standard.value(forKey: "id") as? String {
                    
                    DispatchQueue.main.async {
                        
                        self.userID = Int(uID)
                        self.log.debug("USER AUTO ID： \(self.userID!)")
                        self.monthFeeArray = [MONTH_FEE]()
                        self.get_userMonthFee()
                    }
                }
            }
        }
    }
    
    func get_userMonthFee(){
        
        SVProgressHUD.show()
        self.overlay = UIView(frame: self.view.frame)
        self.overlay!.backgroundColor = UIColor.black
        self.overlay!.alpha = 0.5
        
        self.view.addSubview(self.overlay!)

        
        USER_API().user_monthFee(keys: ["userID" : userID!]) { (response, isSuccess, usageFee) in
            
            if isSuccess {
                
                
                self.monthFeeArray = response
                self.log.warning(self.monthFeeArray)
                DispatchQueue.main.async {
                    
                    self.myTableView.reloadData()
                    self.total_usage_label.text = "\(round(usageFee[0]*100)/100)度"
                    self.total_fee_label.text = "\(round(usageFee[1]*100)/100)元"
                    SVProgressHUD.dismiss()
                    self.overlay?.removeFromSuperview()
                }
                
                if self.monthFeeArray.isEmpty {
                    
                    let alert = CDAlertView(title: "尚未註冊電號", message: "請至 更多>註冊電號 完成新增", type: CDAlertViewType.warning)
                    
                    let okAction = CDAlertViewAction(title: "立刻前往👉", textColor: .red, handler: { (CDAlertViewAction) -> Bool in
                        
                        ((self.tabBarController?.selectedIndex = 3) != nil)
                    })
                    
                    alert.add(action: okAction)
                    alert.show()
                    
                    DispatchQueue.main.async {
                        
                        SVProgressHUD.dismiss()
                        self.overlay?.removeFromSuperview()
                    }
                }
                
                
            } else {
                
                SVProgressHUD.dismiss()
                self.overlay?.removeFromSuperview()
            }
        }
    }

}
