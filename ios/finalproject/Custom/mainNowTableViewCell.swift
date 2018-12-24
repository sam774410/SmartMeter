//
//  mainNowTableViewCell.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/12/23.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import Charts

class mainNowTableViewCell: UITableViewCell {

    
    @IBOutlet weak var meterID: UILabel!
    
    @IBOutlet weak var usage: UILabel!
    
    @IBOutlet weak var fee: UILabel!
    
    @IBOutlet weak var iconView: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(iconName: String, meterID: String, usage: String, fee: String){
        
        self.iconView.image = UIImage(named: iconName)
        self.meterID.text = meterID
        self.usage.text = "\(usage)度"
        self.fee.text = "\(fee)元"
    }
    

//    func updateChart(){
//        
//        usageChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
//        
//        var axisFormatDelgate: IAxisValueFormatter?
//        
//        var dataEntries: [BarChartDataEntry] = []
//        
//       
//            
//        //需設定x, y座標分別需顯示什麼東西
//        let dataEntry_usage = BarChartDataEntry(x: 1,  y: 15)
//        let dataEntry_fee = BarChartDataEntry(x: 1,  y: 200)
//        //最後把每次生成的dataEntry存入到dataEntries當中
//        dataEntries.append(dataEntry_usage)
//        dataEntries.append(dataEntry_usage)
//        //dataEntries.append(dataEntry_fee)
//        
//        
//        //透過BarChartDataSet設定我們要顯示的資料為何，以及圖表下方的label
//        let chartDataSet = BarChartDataSet(values: dataEntries, label: "用電度數")
//        //dataset color
//        chartDataSet.colors = ChartColorTemplates.pastel()
//        
//        
//        //把整個dataset轉換成可以顯示的BarChartData
//        let charData = BarChartData(dataSet: chartDataSet)
//        
//        charData.barWidth = 60
//        charData.setValueFont(UIFont(name:"HelveticaNeue-Light", size:50)!)
//        //最後在指定剛剛連結的myView要顯示的資料為charData
//        usageChart.data = charData
//        usageChart.xAxis.granularity = 1
//    }
}
