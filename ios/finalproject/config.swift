//
//  File.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/26.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import Foundation
import SwiftyBeaver

class CONFIG{
    
    //140.115.82.72:2000
    let default_link: String = "http://127.0.0.1:2000"
    let backup_link: String = "http://127.0.0.1:2000"
    
    let app_version: String = "1.0"
}

class MYLOG{
    
    let log = SwiftyBeaver.self
    init() {
            let console = ConsoleDestination()
            let file = FileDestination()  // log to default swiftybeaver.log file
            log.addDestination(console)
            log.addDestination(file)
    }
}



class Encoding {
    
    // TODO: base64 encoding
    func base64Encoding(str:String)->String{
        let strData = str.data(using: String.Encoding.utf8)
        let base64String = strData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            return base64String!
    }

    // TODO: base64 decoding
    func base64Decoding(encodedStr:String)->String{
        let decodedData = NSData(base64Encoded: encodedStr, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
            
        return decodedString
    }

}

