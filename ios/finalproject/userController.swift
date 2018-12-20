//
//  user.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/24.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyBeaver
import NotificationBannerSwift
import CDAlertView

struct USER_DATAMODEL {
    
    var userFirstName: String?
    var userLastName: String?
    var userID: String?
    var userAcct: String?
    var userPwd: String?
    var userEmail: String?
    var userContactPhone: String?
    var userAddress: String?
    var autoID: String?
}

struct METER_DATAMODEL {
    
    var meterID: String?
    var meterAddress: String?
    var meterStatus: String?
    var meterSuspendType: String?
}

class USER_API {
    
    let log = SwiftyBeaver.self
    var link: String?
    
    init() {

        link = CONFIG().default_link 
        
        //logging
        let console = ConsoleDestination()
        let file = FileDestination()  // log to default swiftybeaver.log file
        log.addDestination(console)
        log.addDestination(file)
    }
    
    func user_register(keys: [String: Any], completion: @escaping(Bool) -> ())  {
        
        var isSuccess = false
        
            Alamofire.request(link!+"/users", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response)  in
                
                self.log.debug(response.result.value)
                
                let jsonResult:JSON = JSON(response.result.value!)
                
                if jsonResult["status"] == 200 {
                    
                    self.log.info("user register successfully")
                    
                    let banner = NotificationBanner(title: "註冊成功", subtitle: "歡迎使用張文翰", style: .success)
                    banner.show()
                    
                    isSuccess = true
                    completion(isSuccess)
                } else if jsonResult["status"] == 500{
                    
                    self.log.info("user register failed")
                    
                    let banner = NotificationBanner(title: "請稍後再試", style: BannerStyle.warning)
                    banner.show()
                    
                    isSuccess = false
                    completion(isSuccess)
                } else {
                    
                    self.log.info("user register unexpected error")
                    
                    let banner = NotificationBanner(title: "請稍後再試", style: BannerStyle.warning)
                    banner.show()
                    
                    isSuccess = false
                    completion(isSuccess)
                }
            }
    }
    
    
    func user_login(keys: [String: Any], completion: @escaping(Bool) -> ()){
        
        var isSuccess = false
        
        Alamofire.request(link!+"/users/auth/id", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                //login success
                self.log.info("user login successfully")
                
                let banner = NotificationBanner(title: "登入成功", style: .success)
                banner.show()
                
                isSuccess = true
                completion(isSuccess)
            }else if jsonResult["status"] == 204 {
                
                //login fail(no acct)
                self.log.info("user login fail")
                
                let banner = NotificationBanner(title: "帳號或密碼錯誤", style: BannerStyle.warning)
                banner.show()
                
                isSuccess = false
                completion(isSuccess)
            }else {
                
                //unexcepted fail
                self.log.info("user login unexcepted fail")
                
                let banner = NotificationBanner(title: "請稍後再試", style: BannerStyle.warning)
                banner.show()
                
                isSuccess = false
                completion(isSuccess)
            }
        }
    }
    
    func user_query(keys: [String: Any], completion: @escaping([String]) -> ()) {
        
        var user: [String] = []
        
        Alamofire.request(link!+"/users/id", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                self.log.debug("query successfully")
                self.log.info(jsonResult["response"])
                
                user.append(jsonResult["response"][0]["FirstName"].string!)
                user.append(jsonResult["response"][0]["LastName"].string!)
                user.append(jsonResult["response"][0]["EmailAddress"].string!)
                user.append(jsonResult["response"][0]["ContactPhoneNum"].string!)
                user.append(jsonResult["response"][0]["ContactAddress"].string!)
                user.append(jsonResult["response"][0]["Password"].string!)
                user.append(jsonResult["response"][0]["Account"].string!)
                user.append(String(jsonResult["response"][0]["ID"].int!))
                
//                UserDefaults.standard.set(String(jsonResult["response"][0]["ID"].int!), forKey: "id")
                
                self.log.warning("user array：\(user)")
                completion(user)
            }else {
                
                self.log.debug("query fail")
            }
        }
    }
    
    func user_updateInfo(keys: [String: Any], completion: @escaping (Bool) -> ()) {
        
        var isSuccess = false
        
        Alamofire.request(link!+"/users/id", method: HTTPMethod.put, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                //update success
                self.log.info("user update info successfully")
                isSuccess = true
                completion(isSuccess)
            } else {
                
                //update fail
                self.log.info("user update info fail")
                isSuccess = false
                completion(isSuccess)
            }
        }
    }
    
    func user_updatePwd(keys: [String: Any], completion: @escaping(Bool) -> ()){
        
        var isSuccess = false
        
        Alamofire.request(link!+"/users/id/pwd", method: HTTPMethod.put, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                //update success
                self.log.info("user update pwd successfully")
                isSuccess = true
                completion(isSuccess)
            } else {
                
                //update fail
                self.log.info("user update pwd fail")
                isSuccess = false
                completion(isSuccess)
            }
        }
    }
    
    func user_sendPwd(keys: [String: Any], completion: @escaping(Bool) -> ()){
        
        var isSuccess = false
        
        Alamofire.request(link!+"/users/forget/pwd", method: HTTPMethod.post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                //send success
                self.log.info("send password successfully")
                isSuccess = true
                completion(isSuccess)
            } else {
                
                //send fail
                self.log.info("send password fail")
                isSuccess = false
                completion(isSuccess)
            }
        }
    }
    
    
    func user_queryMeter(keys: [String: Any], completion: @escaping([METER_DATAMODEL], Bool) -> () ) {
    
        Alamofire.request(link!+"/users/retrieveMeter", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            let jsonResult: JSON = JSON(response.result.value!)
            self.log.debug(jsonResult)
            
            var isSuccess = false
            
            if jsonResult["status"] == 200 {
                
                var meterData = [METER_DATAMODEL]()
                
                isSuccess = true
                //query success
                self.log.info("query meter successfully")
                
                    for i in 0...jsonResult["response"].count-1 {
                        
                        var item = METER_DATAMODEL()

                        item.meterID = jsonResult["response"][i]["ID"].stringValue
                        item.meterAddress = jsonResult["response"][i]["Address"].stringValue
                        item.meterStatus = jsonResult["response"][i]["Status"].stringValue

                        meterData.append(item)                      
                    }
                
                    completion(meterData, isSuccess)
                
                } else if jsonResult["status"] == 204  {
                    
                    isSuccess = false
                    var meterData = [METER_DATAMODEL]()
                    
                    //query fail
                    self.log.info("query meter empty")

                    completion(meterData, isSuccess)
                }else  {
                
                    isSuccess = false
                    var meterData = [METER_DATAMODEL]()
                
                    //query fail
                    self.log.info("query meter fail")
                
                    completion(meterData, isSuccess)
                }
            }
        }
    
    func user_addMeter(keys: [String: Any], completion: @escaping(Bool) -> ()) {
        
            
        var isSuccess: Bool = false
        
        Alamofire.request(link!+"/users/update_meter", method: .put, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                ALERT().banner(tittle: "新增電號成功", subtitle: "", style: BannerStyle.success)
                
                isSuccess = true
                completion(isSuccess)
            } else if jsonResult["status"] == 403 {
                
                ALERT().banner(tittle: "此電號已註冊", subtitle: "請確認電號", style: BannerStyle.danger)
                
                completion(isSuccess)
                
            } else {
                
                ALERT().banner(tittle: "請稍後再試", subtitle: "", style: BannerStyle.warning)
                
                completion(isSuccess)
            }
        }
    }
    
    func user_addContract(keys: [String: Any], completion: @escaping(Bool) -> ()) {
        
        var isSuccess: Bool = false
        
        Alamofire.request(link!+"/users/add_contract", method: .put, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                self.log.debug("add contract successfully")
                
                isSuccess = true
                completion(isSuccess)
            }  else {
                
                self.log.debug("add contract fail")
                completion(isSuccess)
            }
        }
    }
    
    
    func user_stopMeter(keys: [String: Any], completion: @escaping(Bool)->()) {
        
        var isSuccess = false
        
        Alamofire.request(link!+"/users/stop_meter", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                self.log.debug("stop meter request sended")
                
                isSuccess = true
                completion(isSuccess)
            }  else {
                
                self.log.debug("stop meter request sended fail")
                completion(isSuccess)
            }
        }
    }
    
    
    func user_querySuspendStatus(keys: [String: Any], completion: @escaping([String])->()) {
        
        Alamofire.request(link!+"/users/post_suspendapply_status", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                self.log.debug("query meter suspend successfully \(keys)")
                var result: [String] = []
                
                result.append(jsonResult["response"][0]["Status"].stringValue)
                result.append(jsonResult["response"][0]["Type"].stringValue)
                
                self.log.debug(result)
                
                completion(result)
            }  else {
                
                self.log.debug("query meter suspend fail")
                
                completion([])
            }
        }
    }
    
    //取消申請
    func user_cancelStopMeter(keys: [String: Any], completion: @escaping(Bool)->()) {
        
        var isSuccess = false
        
        Alamofire.request(link!+"/users/cancel_stop_meter", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                self.log.debug("cancel stop meter successfully")
                isSuccess = true
                completion(isSuccess)
            }else {
                
                self.log.debug("cancel stop meter fail")
                completion(isSuccess)
            }
        }
    }
    
    //取消回復用電
    func user_cancelRecoveryMeter(keys: [String: Any], completion: @escaping(Bool)->()) {
        
        var isSuccess = false
        
        Alamofire.request(link!+"/users/cancel_recovery_meter", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                self.log.debug("cancel recovery meter successfully")
                isSuccess = true
                completion(isSuccess)
            }else {
                
                self.log.debug("cancel recovery meter fail")
                completion(isSuccess)
            }
        }
    }
    
    //廢止用電
    func user_abolishMeter(keys: [String: Any], completion: @escaping(Bool)->()) {
        
        var isSuccess = false
        
        Alamofire.request(link!+"/users/abolish_meter", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                self.log.debug("user abolish meter successfully")
                isSuccess = true
                completion(isSuccess)
            } else {
                
                self.log.debug("user abolish meter fail")
                completion(isSuccess)
            }
        }
    }
    
    
    //恢復用電
    func user_recoveryMeter(keys: [String: Any], completion: @escaping(Bool)->()){
        
        var isSuccess = false
    
        Alamofire.request(link!+"/users/recovery_meter", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                self.log.debug("user recovery meter apply successfully")
                isSuccess = true
                completion(isSuccess)
            } else {
                
                self.log.debug("user recovery meter apply fail")
                completion(isSuccess)
            }
        }
    }
}

