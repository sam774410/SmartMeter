//
//  meterListViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/14.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import SVProgressHUD
import CDAlertView
import PullToRefresh

class meterListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    let log = MYLOG().log
    
    @IBOutlet weak var myTableView: UITableView!
    var meterDataArray = [METER_DATAMODEL]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meterDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! meterListTableViewCell
        
        cell.setUpCell(meter_id: meterDataArray[indexPath.row].meterID!, meter_address: meterDataArray[indexPath.row].meterAddress!, meter_status: meterDataArray[indexPath.row].meterStatus!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //check meter status "1" -> "使用中", "2" -> "暫停中"
        if meterDataArray[indexPath.row].meterStatus == "-1" {
            
            //handler stoped meter -> recovery
            
            let alert = UIAlertController(title: "請選擇", message: nil, preferredStyle: .actionSheet)
            
            let recoveryAction = UIAlertAction(title: "恢復用電", style: .default) { (UIAlertAction) in
                
                //recovery action here
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
            
            alert.addAction(recoveryAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }else if meterDataArray[indexPath.row].meterStatus == "1"{
            
            //handler on use meter -> stop
            
            let alert = UIAlertController(title: "請選擇", message: nil, preferredStyle: .actionSheet)
            
            let suspendApply = UIAlertAction(title: "暫停用電", style: .default) { (UIAlertAction) in
                
                if let meterStatusVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meterStatusVC") as? mainApplyPowerOutViewController{
                    
                    meterStatusVC.isSuspendOrStop = true
                    meterStatusVC.isShowStepView = false
                    meterStatusVC.meterID = self.meterDataArray[indexPath.row].meterID
                    self.navigationController?.pushViewController(meterStatusVC, animated: true)
                }
            }
            
            let stopApply = UIAlertAction(title: "廢止用電", style: .default) { (UIAlertAction) in
                
                if let meterStatusVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meterStatusVC") as? mainApplyPowerOutViewController{
                    
                    meterStatusVC.isSuspendOrStop = false
                    meterStatusVC.isShowStepView = false
                    meterStatusVC.meterID = self.meterDataArray[indexPath.row].meterID
                    self.navigationController?.pushViewController(meterStatusVC, animated: true)
                }
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
            
            alert.addAction(suspendApply)
            alert.addAction(stopApply)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        } else if meterDataArray[indexPath.row].meterStatus == "0" {
            
            //handle apply step
            
            if let meterStatusVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meterStatusVC") as? mainApplyPowerOutViewController {
                
                meterStatusVC.isShowStepView = true
                meterStatusVC.meterID = self.meterDataArray[indexPath.row].meterID
                
                self.navigationController?.pushViewController(meterStatusVC, animated: true)
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.delegate = self
        myTableView.tableFooterView = UIView()
        //myTableView.isScrollEnabled = false
        
        let refresher = PullToRefresh()
        myTableView.addPullToRefresh(refresher) {
            
            self.meterDataArray = [METER_DATAMODEL]()
            self.loadMeterData()
            self.myTableView.endAllRefreshing()
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        meterDataArray = [METER_DATAMODEL]()
        loadMeterData()
    }
    
    
    @IBAction func backToMeterList(_ segue: UIStoryboardSegue) {
        
       
    }
    
    
    func loadMeterData() {
        
        SVProgressHUD.show()
        // load user info
        if let acct = UserDefaults.standard.value(forKey: "acct") as? String{
            log.info("ACCOUNT:\(acct)")
            
            let parameters = ["Account": acct] as [String: Any]
            USER_API().user_query(keys: parameters) { (userdata) in
                
                self.log.info(userdata)
                
                UserDefaults.standard.set(userdata[7], forKey: "id")
                self.log.debug("USER AUTO ID : \(userdata[7])")
                
                let parameters = ["UserID": userdata[7]]
                USER_API().user_queryMeter(keys: parameters, completion: { (userMeterData, isSuccess) in
                    
                    
                    self.log.debug  ("電表資料成功抓取：\(isSuccess)")
                    
                    if isSuccess {
                        
                        self.meterDataArray = userMeterData
                        
                        //self.log.debug(userMeterData)
                        
                        
                        DispatchQueue.main.async {
                            
                            self.myTableView.reloadData()
                            SVProgressHUD.dismiss()
                        }
                    } else {
                        
                        let alert = CDAlertView(title: "尚未新增電表", message: "請至 更多>新增電號 完成新增", type: CDAlertViewType.warning)
                        
                        let okAction = CDAlertViewAction(title: "立刻前往👉", textColor: .red, handler: { (CDAlertViewAction) -> Bool in
                            
                            ((self.tabBarController?.selectedIndex = 3) != nil)
                        })
                        
                        alert.add(action: okAction)
                        alert.show()
                        
                        DispatchQueue.main.async {
                            
                            SVProgressHUD.dismiss()
                        }
                    }
                })
                
            }
        }
    }

   
}

