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

struct USER_DATAMODEL {
    
    var userFirstName: String?
    var userLastName: String?
    var userID: String?
    var userAcct: String?
    var userPwd: String?
    var userEmail: String?
    var userContactPhone: String?
    var userAddress: String?
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
    
    func user_register(keys: [String: Any]){
        
        Alamofire.request(link!, method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult:JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                self.log.info("user register successfully")
            } else if jsonResult["status"] == 500{
                
                self.log.info("user register failed")
            } else {
                
                self.log.info("user register unexpected error")
            }
        }
    }
    
    
}
