//
//  meterListTableViewCell.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/14.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import CDAlertView

class meterListTableViewCell: UITableViewCell {

    @IBOutlet weak var meter_lable: UILabel!
    @IBOutlet weak var address_lable: UILabel!
    
    @IBOutlet weak var status_lable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(meter_id: String, meter_address: String, meter_status: String) {
        
        self.meter_lable.text = meter_id
        self.address_lable.text = meter_address
        
        if meter_status == "1" {
            
            self.status_lable.text = "使用中"
            self.status_lable.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        } else if meter_status == "-1"{
            
            self.status_lable.text = "暫停中"
            self.status_lable.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else if meter_status == "0"{
            
            self.status_lable.text = "申請中"
            self.status_lable.textColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        } else {
            
            self.status_lable.text = ""
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
