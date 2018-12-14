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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(meter_id: String, address: String) {
        
        self.meter_lable.text = meter_id
        self.address_lable.text = address
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
