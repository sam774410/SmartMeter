//
//  mainHistoryViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/24.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import Charts

class mainHistoryViewController: UIViewController {

    
    @IBOutlet weak var barChart: BarChartView!
    
    let log = MYLOG().log
    let monthsArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var historyArray = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyArray = [1285, 1079, 1199, 1177, 1398, 1457, 1731, 1660, 1778, 1671, 1633, 1550]
        updateChart()
        
    }
    
    func updateChart(){
        
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        var axisFormatDelgate: IAxisValueFormatter?
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<monthsArray.count {
            
            //需設定x, y座標分別需顯示什麼東西
            let dataEntry = BarChartDataEntry(x: Double(i),  y: historyArray[i])
            //最後把每次生成的dataEntry存入到dataEntries當中
            dataEntries.append(dataEntry)
        }
        
        //透過BarChartDataSet設定我們要顯示的資料為何，以及圖表下方的label
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "每月歷史用電紀錄(單位：度)")
        //dataset color
        chartDataSet.colors = ChartColorTemplates.pastel()
        
        //label=>bottom
        barChart.xAxis.labelPosition = .bottom
        
        //把整個dataset轉換成可以顯示的BarChartData
        let charData = BarChartData(dataSet: chartDataSet)
        
        //最後在指定剛剛連結的myView要顯示的資料為charData
        barChart.data = charData
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthsArray)
        barChart.xAxis.granularity = 1
    }

}
