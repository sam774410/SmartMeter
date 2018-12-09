//
//  mainPublicTableViewCell.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/9.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit

class mainPublicTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var funcLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    func setUpCell(iconName: String, funcName: String, description: String){
        
        self.iconView.image = UIImage(named: iconName)
        self.funcLabel.text = funcName
        self.descriptionLabel.text = description
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }

}
