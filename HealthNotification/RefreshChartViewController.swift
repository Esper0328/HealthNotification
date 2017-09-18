//
//  RefreshChartViewController.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/09/18.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit
import Charts

class RefreshChartViewController: UIViewController{
    
    @IBAction func endEvent(_ sender: Any) {
        performSegue(withIdentifier: "top", sender: nil)
    }

    @IBOutlet weak var chartview: BarChartView!
    /*
    let days_per_week = 7
    let hours_per_day = 24
    let minutes_per_hour = 60
    let seconds_per_minute = 60
    
    var timer: Timer!
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // y軸のプロットデータ
        readyForChart()
    }
    
    func readyForChart(){
        let freqOfRefreshCheck = [
            refreshCheckResult[RefreshId.GoOut.rawValue].freq,
            refreshCheckResult[RefreshId.Neck.rawValue].freq,
            refreshCheckResult[RefreshId.Back.rawValue].freq,
            refreshCheckResult[RefreshId.LowBack.rawValue].freq
        ]
        setChart(y: freqOfRefreshCheck, chartview: chartview)
    }
    
    
    /*
    func setResetStressCheckFreqTimer(){
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second, .weekday], from: date)
        
        let next_time_interval_day : Int = (days_per_week + 1 - (components.weekday!)) % days_per_week
        let next_time_interval_hour : Int = hours_per_day - (components.hour!) - 1
        let next_time_interval_minute : Int = minutes_per_hour - (components.minute!) - 1
        let next_time_interval_seconds : Int = seconds_per_minute - (components.second!)
        let next_time_interval : UInt32
            = UInt32(hours_per_day * next_time_interval_day * minutes_per_hour * seconds_per_minute)
                + UInt32(minutes_per_hour * seconds_per_minute * next_time_interval_hour)
                + UInt32(seconds_per_minute * next_time_interval_minute)
                + UInt32(next_time_interval_seconds)
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(next_time_interval), target: self, selector: #selector(self.notifyTimeout), userInfo: nil, repeats: false)
    }
 */
    
    func notifyTimeout(){
        resetStressCheckFreq()
        //setResetStressCheckFreqTimer()
    }
    
    func resetStressCheckFreq(){
        for i in 0..<stressCheckResult.count {
            stressCheckResult[i].freq = 0
        }
    }
    
    
    func setChart(y: [Double], chartview: BarChartView){
        var dataEntries = [BarChartDataEntry]()
        
        for (i, val) in y.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: val) // X軸データは、0,1,2,...
            dataEntries.append(dataEntry)
        }
        // グラフをUIViewにセット
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "実施回数")
        // X軸のラベルを設定
        let xaxis = XAxis()
        xaxis.valueFormatter = RefreshCheckBarChartFormatter()
        chartview.xAxis.labelCount = RefreshCheckBarChartFormatter().getNumberOfSign()
        chartDataSet.colors = [UIColor(red: 0, green: 0/255, blue: 140/255, alpha: 1)]
        chartDataSet.label = "実施回数"
        chartview.xAxis.valueFormatter = xaxis.valueFormatter
        chartview.xAxis.labelPosition = .bottom
        chartview.data = BarChartData(dataSet: chartDataSet)
        
        // グラフの背景色
        chartview.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        // グラフの棒をニョキッとアニメーションさせる
        chartview.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        // 横に赤いボーダーラインを描く
        let ll = ChartLimitLine(limit: 7.0)
        chartview.leftAxis.addLimitLine(ll)
        chartview.pinchZoomEnabled = false
        chartview.rightAxis.enabled = false
        chartview.leftAxis.enabled = true
        chartview.leftAxis.axisMaximum = 8.0
        chartview.leftAxis.axisMinimum = 0.0
        chartview.leftAxis.labelCount = Int(4) //y軸ラベルの表示数
        chartview.chartDescription?.text = ""
    }
}



public class RefreshCheckBarChartFormatter: NSObject, IAxisValueFormatter{
    // x軸のラベル
    var refresh: [String]! = ["外出", "首肩腕", "肩甲骨", "足腰"]
    // デリゲート。TableViewのcellForRowAtで、indexで渡されたセルをレンダリングするのに似てる。
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return refresh[Int(value)]
    }
    
    public func getNumberOfSign() -> Int {
        return refresh.count
    }
}


