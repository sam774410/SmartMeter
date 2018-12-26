//
//  mainHistoryViewController.swift
//  finalproject
//
//  Created by 呂明聲 on 2018/11/24.
//  Copyright © 2018 MingShengLyu. All rights reserved.
//

import UIKit
import Charts
import NotificationBannerSwift
import SVProgressHUD

class mainHistoryViewController: UIViewController {

    @IBAction func back_Btn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    var log = MYLOG().log
    var myDate = "2017-01-01"
    @IBOutlet weak var date_TF: UITextField!
    private var datePicker: UIDatePicker?
    
    //chart info
    var sourceInfo: [String] = []
    var totalInfo: [Double] = []
    
    @IBOutlet weak var barChart: BarChartView!
    
    @IBAction func query_Btn(_ sender: Any) {
        
        view.endEditing(true)
        
        DispatchQueue.main.async {
            
            SVProgressHUD.show()
            PLANT_API().plant_historySupply(keys: ["SupplyDate": self.myDate]) { (result, isSuccess) in
                
                if isSuccess {
                    
                    self.sourceInfo = []
                    self.totalInfo = []
                    
                    for i in 0...4 {
                        
                        self.sourceInfo.append(result[i].plantPowerSource!)
                        self.totalInfo.append(result[i].plantSupply!)
                    }
                    self.log.debug(self.totalInfo)
                    SVProgressHUD.dismiss()
                    self.updateChart(info: self.totalInfo, descriptin: self.sourceInfo)
                } else {
                    
                    ALERT().banner(tittle: "請稍後再試", subtitle: "", style: BannerStyle.warning)
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    //let monthsArray = ["太陽能", "核能", "水力", "火力", "風力"]
    //var historyArray = [100, 200.0, 300, 349, 200]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        PLANT_API().plant_historySupply(keys: ["SupplyDate": self.myDate]) { (result, isSuccess) in
            
            if isSuccess {
                
                self.sourceInfo = []
                self.totalInfo = []
                
                for i in 0...4 {
                    
                    self.sourceInfo.append(result[i].plantPowerSource!)
                    self.totalInfo.append(result[i].plantSupply!)
                }
                
                self.log.debug(self.sourceInfo)
                self.log.debug(self.totalInfo)
                
                SVProgressHUD.dismiss()
                self.updateChart(info: self.totalInfo, descriptin: self.sourceInfo)
            } else {
                
                ALERT().banner(tittle: "請稍後再試", subtitle: "", style: BannerStyle.warning)
                SVProgressHUD.dismiss()
            }
        }
        
     
       
        
        //init date picker
        setUpDatePicker ()
    }
    
    func updateChart(info: [Double], descriptin: [String]){
        
        barChart.noDataText = "loading..."
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.0)
        
        var axisFormatDelgate: IAxisValueFormatter?
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<descriptin.count {
            
            //需設定x, y座標分別需顯示什麼東西
            let dataEntry = BarChartDataEntry(x: Double(i),  y: info[i])
            //最後把每次生成的dataEntry存入到dataEntries當中
            dataEntries.append(dataEntry)
        }
        
        //透過BarChartDataSet設定我們要顯示的資料為何，以及圖表下方的label
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "發電來源紀錄(單位：萬瓩)")
        //dataset color
        chartDataSet.colors = ChartColorTemplates.pastel()
        
        //label=>bottom
        barChart.xAxis.labelPosition = .bottom
        
        //把整個dataset轉換成可以顯示的BarChartData
        let charData = BarChartData(dataSet: chartDataSet)
        
        //最後在指定剛剛連結的myView要顯示的資料為charData
        barChart.data = charData
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: descriptin)
        barChart.xAxis.granularity = 1
    }
    
    func setUpDatePicker () {
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        let dateFormatter = DateFormatter()
        var minDate = "2017-01-01"
        var maxDate = "2017-12-31"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var newMinDate = dateFormatter.date(from: minDate)
        var newMaxDate = dateFormatter.date(from: maxDate)
        datePicker?.minimumDate = newMinDate
        datePicker?.maximumDate = newMaxDate
        
        datePicker?.addTarget(self, action: #selector(mainHistoryViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mainHistoryViewController.tapView(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        date_TF.inputView = datePicker
    }
    
    @objc func tapView(gestureRecognizer: UITapGestureRecognizer){
        
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "zh_TW")
        self.myDate = dateFormatter.string(from: datePicker.date)
        date_TF.text = dateFormatter.string(from: datePicker.date)
        
        self.log.debug("select date： \(self.myDate)")
    }

}
