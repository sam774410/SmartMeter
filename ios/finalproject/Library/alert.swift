//
//  alert.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/5.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import Foundation
import CDAlertView
import NotificationBannerSwift

class ALERT {
    
    func alert(title: String, subTitle: String, type: CDAlertViewType){
        
        let alert = CDAlertView(title: title, message: subTitle, type: type)
        let okAction = CDAlertViewAction(title: "確認")
        alert.add(action: okAction)
        alert.show()
    }
    
    func banner(tittle: String, subtitle: String, style: BannerStyle ) {
        
        let mbanner = NotificationBanner(title: tittle, subtitle: subtitle, style: style)
        mbanner.show()
        
    }
}
