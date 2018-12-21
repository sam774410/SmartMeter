//
//  supplyController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/21.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyBeaver
import NotificationBannerSwift
import CDAlertView


struct PLANT_DATAMODEL {
    
    var plantPowerSource: String?
    var plantSupply: Double?
}


class PLANT_API {
    
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
    
    func plant_historySupply(keys: [String: Any], completion: @escaping ([PLANT_DATAMODEL], Bool) -> ()) {
        
        var isSuccess = false
        var result: [PLANT_DATAMODEL] = []
        
        Alamofire.request(link!+"/supply", method: .post, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            self.log.debug(response.result.value)
            
            let jsonResult: JSON = JSON(response.result.value!)
            
            if jsonResult["status"] == 200 {
                
                self.log.debug("query plant supply successfully")
                
                for i in 0..<jsonResult["response"].count {
                    
                    var item = PLANT_DATAMODEL()
                    
                    item.plantPowerSource = jsonResult["response"][i]["PowerSource"].stringValue
                    item.plantSupply = jsonResult["response"][i]["total"].doubleValue
                    
                    result.append(item)
                }
                
                isSuccess = true
                completion(result, isSuccess)
            } else {
                
                self.log.debug("query plant supply fail")
                
                completion(result, isSuccess)
            }
         }
    }
}

