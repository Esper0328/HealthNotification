//
//  ChartViewController.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/09/05.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController{
    
    enum StressSignBarType{
        case Strong
        case Mid1
        case Mid2
        case Weak
    }
    
    @IBOutlet weak var chartTitle: UILabel!
    
    @IBAction func backEvent(_ sender: Any) {
        performSegue(withIdentifier: "top", sender: nil)
    }
    
    @IBOutlet weak var chartView1: BarChartView!
    @IBOutlet weak var chartView2: BarChartView!
    @IBOutlet weak var chartView3: BarChartView!
    @IBOutlet weak var chartView4: BarChartView!
    
    let days_per_week = 7
    let hours_per_day = 24
    let minutes_per_hour = 60
    let seconds_per_minute = 60
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // y軸のプロットデータ
        readyForChart()
    }
    
    func readyForChart(){
        chartTitle.text = "週のストレスサイン頻度"
        let freqOfStrongStressSign = [
            stressCheckResult[StressSignId.Jinmashin.rawValue].freq,
            stressCheckResult[StressSignId.Tears.rawValue].freq,
            stressCheckResult[StressSignId.Suicide.rawValue].freq,
            stressCheckResult[StressSignId.CannotDoAny.rawValue].freq
        ]
        let freqOfMidStressSign1 = [
            stressCheckResult[StressSignId.Konaien.rawValue].freq,
            stressCheckResult[StressSignId.StomachAche.rawValue].freq,
            stressCheckResult[StressSignId.Dizzy.rawValue].freq,
            stressCheckResult[StressSignId.Sleepy.rawValue].freq,
            stressCheckResult[StressSignId.ShallowSleep.rawValue].freq,
            stressCheckResult[StressSignId.Nightmare.rawValue].freq,
            stressCheckResult[StressSignId.Silent.rawValue].freq
        ]
        let freqOfMidStressSign2 = [
            stressCheckResult[StressSignId.BadLook.rawValue].freq,
            stressCheckResult[StressSignId.Frustrated.rawValue].freq,
            stressCheckResult[StressSignId.Tired.rawValue].freq,
            stressCheckResult[StressSignId.StrongStiffNeck.rawValue].freq,
            stressCheckResult[StressSignId.CarelessMiss.rawValue].freq,
            stressCheckResult[StressSignId.AvoidCommunication.rawValue].freq,
            stressCheckResult[StressSignId.DrinkThreeTimesMore.rawValue].freq
        ]
        let freqOfWeakStressSign = [
            stressCheckResult[StressSignId.WeakStiffNeck.rawValue].freq,
            stressCheckResult[StressSignId.Tension.rawValue].freq,
            stressCheckResult[StressSignId.EatSweets.rawValue].freq,
            stressCheckResult[StressSignId.Drink.rawValue].freq,
            stressCheckResult[StressSignId.RepeatSame.rawValue].freq
        ]
        
        setStressCheckChart(y: freqOfStrongStressSign, chartview: chartView1, stressSignBarType: .Strong)
        setStressCheckChart(y: freqOfMidStressSign1, chartview: chartView2, stressSignBarType: .Mid1)
        setStressCheckChart(y: freqOfMidStressSign2, chartview: chartView3, stressSignBarType: .Mid2)
        setStressCheckChart(y: freqOfWeakStressSign, chartview: chartView4, stressSignBarType: .Weak)
        setResetStressCheckFreqTimer()
    }
    
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
    
    func notifyTimeout(){
        resetStressCheckFreq()
        setResetStressCheckFreqTimer()
    }
    
    func resetStressCheckFreq(){
        for i in 0..<stressCheckResult.count {
            stressCheckResult[i].freq = 0
        }
    }
    
    func setStressCheckChart(y: [Double], chartview: BarChartView, stressSignBarType: StressSignBarType) {
        // プロットデータ(y軸)を保持する配列
        var dataEntries = [BarChartDataEntry]()
        
        for (i, val) in y.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: val) // X軸データは、0,1,2,...
            dataEntries.append(dataEntry)
        }
        // グラフをUIViewにセット
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "サイン頻度")
        
        // X軸のラベルを設定
        let xaxis = XAxis()
        
        switch stressSignBarType{
        case .Strong:
            xaxis.valueFormatter = StrongSignBarChartFormatter()
            chartview.xAxis.labelCount = StrongSignBarChartFormatter().getNumberOfSign()
            chartDataSet.colors = [UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)]
            chartDataSet.label = "強サイン頻度"
        case .Mid1:
            xaxis.valueFormatter = MidSign1BarChartFormatter()
            chartview.xAxis.labelCount = MidSign1BarChartFormatter().getNumberOfSign()
            chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
            chartDataSet.label = "中サイン１頻度"
        case .Mid2:
            xaxis.valueFormatter = MidSign2BarChartFormatter()
            chartview.xAxis.labelCount = MidSign2BarChartFormatter().getNumberOfSign()
            chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
            chartDataSet.label = "中サイン２頻度"
        case .Weak:
            xaxis.valueFormatter = WeakSignBarChartFormatter()
            chartview.xAxis.labelCount = WeakSignBarChartFormatter().getNumberOfSign()
            chartDataSet.label = "弱サイン頻度"
        }
        chartview.xAxis.valueFormatter = xaxis.valueFormatter
        chartview.xAxis.labelPosition = .bottom
        chartview.data = BarChartData(dataSet: chartDataSet)

        // グラフの背景色
        chartview.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        // グラフの棒をニョキッとアニメーションさせる
        chartview.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        // 横に赤いボーダーラインを描く
        let ll = ChartLimitLine(limit: 3.0)
        chartview.leftAxis.addLimitLine(ll)
        chartview.pinchZoomEnabled = false
        chartview.rightAxis.enabled = false
        chartview.leftAxis.enabled = true
        chartview.leftAxis.axisMaximum = 7.0
        chartview.leftAxis.axisMinimum = 0.0
        chartview.leftAxis.labelCount = Int(4) //y軸ラベルの表示数
        chartview.chartDescription?.text = ""
    }
    
    func setRefreshCheckChart(y: [Double], chartview: BarChartView){
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
        chartDataSet.colors = [UIColor(red: 0, green: 0/255, blue: 180/255, alpha: 1)]
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

public class StrongSignBarChartFormatter: NSObject, IAxisValueFormatter{
    // x軸のラベル
    var sign: [String]! = ["蕁麻疹", "涙出る", "希死念慮", "何もできない"]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return sign[Int(value)]
    }
    
    public func getNumberOfSign() -> Int {
        return sign.count
    }
}

public class MidSign1BarChartFormatter: NSObject, IAxisValueFormatter{
    // x軸のラベル
    var sign: [String]! = ["口内炎", "腹痛", "顔張り", "眠気", "浅い睡眠", "悪夢", "無口"]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return sign[Int(value)]
    }
    public func getNumberOfSign() -> Int {
        return sign.count
    }
}
public class MidSign2BarChartFormatter: NSObject, IAxisValueFormatter{
    // x軸のラベル
    var sign: [String]! = ["外見悪", "苛々", "疲労感", "凝り強", "ミス増", "回避", "飲酒増"]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return sign[Int(value)]
    }
    public func getNumberOfSign() -> Int {
        return sign.count
    }
}

public class WeakSignBarChartFormatter: NSObject, IAxisValueFormatter{
    // x軸のラベル
    var sign: [String]! = ["凝り", "緊張感", "甘いもの", "酒", "仕事の虫"]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return sign[Int(value)]
    }
    public func getNumberOfSign() -> Int {
        return sign.count
    }
}


