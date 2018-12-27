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
import LocalAuthentication
import NotificationBannerSwift

class meterListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    let log = MYLOG().log
    var overlay : UIView?
    
    @IBOutlet weak var myTableView: UITableView!
    var meterDataArray = [METER_DATAMODEL]()
    var userID: Int?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meterDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row > meterDataArray.count-1){
            return UITableViewCell()
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! meterListTableViewCell
            cell.setUpCell(meter_id: meterDataArray[indexPath.row].meterID!, meter_address: meterDataArray[indexPath.row].meterAddress!, meter_status: meterDataArray[indexPath.row].meterStatus!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //check meter status "1" -> "使用中", "-1" -> "暫停中", "0" -> "申請中"
        if meterDataArray[indexPath.row].meterStatus == "-1" {
            
            //handler stoped meter -> recovery
            
            let alert = UIAlertController(title: "請選擇", message: nil, preferredStyle: .actionSheet)
            
            let recoveryAction = UIAlertAction(title: "恢復用電", style: .default) { (UIAlertAction) in
                
                //recovery action here
                if let meterStatusVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meterStatusVC") as? mainApplyPowerOutViewController{
                    
                    //meterStatusVC.isSuspendOrStop = true
                    meterStatusVC.isRecoveryMeter = true
                    meterStatusVC.isShowStepView = false
                    meterStatusVC.meterID = self.meterDataArray[indexPath.row].meterID
                    self.navigationController?.pushViewController(meterStatusVC, animated: true)
                }
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
            
            let stopApply = UIAlertAction(title: "註銷電號", style: .default) { (UIAlertAction) in
                
                if let meterStatusVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "meterStatusVC") as? mainApplyPowerOutViewController{
                    
                    
                    let alert = CDAlertView(title: "確定註銷電號？", message: "", type: CDAlertViewType.warning)
                    let cancelAction = CDAlertViewAction(title: "取消", textColor: .red)
                    let okAction = CDAlertViewAction(title: "確定", handler: { (CDAlertViewAction) -> Bool in
                        
                        self.auththentication(completion: { (isSuccess) in
                            
                            if isSuccess {
                                
                                //廢止用電
                                
                                let parameters = ["userID": self.userID!, "meterID": Int(self.meterDataArray[indexPath.row].meterID!)] as [String: Any]
                                
                                USER_API().user_abolishMeter(keys: parameters, completion: { (isSuccess) in
                                    
                                    if isSuccess {
                                        
                                        ALERT().banner(tittle: "註銷電號申請成功", subtitle: "電號編號：\(self.meterDataArray[indexPath.row].meterID!)", style: BannerStyle.success)
                                        
                                        //reload meter

                                        self.meterDataArray = [METER_DATAMODEL]()
                                        self.loadMeterData()
                                    } else {
                                        
                                        ALERT().banner(tittle: "請稍後再試", subtitle: "", style: BannerStyle.warning)
                                    }
                                })
                            }
                        })
                        
                        return true
                    })
                    
                    alert.add(action: cancelAction)
                    alert.add(action: okAction)
                    alert.show()
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
            
            DispatchQueue.main.async {
                
                self.meterDataArray = [METER_DATAMODEL]()
                self.loadMeterData()
                self.myTableView.endAllRefreshing()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //get user auto id perfprom query
        if let uID = UserDefaults.standard.value(forKey: "id") as? String {
            
            self.userID = Int(uID)
            log.debug("USER AUTO ID： \(userID!)")
            
        }
        
        DispatchQueue.main.async {

            self.meterDataArray = [METER_DATAMODEL]()
            self.loadMeterData()

        }
    }
    
    
    @IBAction func backToMeterList(_ segue: UIStoryboardSegue) {
        
       
    }
    
    
    func loadMeterData() {
        
        SVProgressHUD.show()
        
        self.overlay = UIView(frame: self.view.frame)
        self.overlay!.backgroundColor = UIColor.black
        self.overlay!.alpha = 0.5
        
        self.view.addSubview(self.overlay!)

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
                            self.overlay?.removeFromSuperview()
                        }
                    } else {
                        
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
                })
            }
        }else {
            
            DispatchQueue.main.async {
                
                SVProgressHUD.dismiss()
                self.overlay?.removeFromSuperview()
            }
        }
    }
    
    
    func auththentication(completion: @escaping(Bool) -> ()) {
        
        let context = LAContext()
        var error: NSError?
        let description: String = "驗證起來！"
        var isSuccess = false
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: description) { (success, error) in
                
                if (success) {
                    
                    self.log.info("user廢止驗證成功")
                    
                    isSuccess = true
                    completion(isSuccess)
                    
                } else {
                    
                    self.log.info("user廢止驗證失敗")
                    
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

