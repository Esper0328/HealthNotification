//
//  SleepDebtHistoryViewController.swift
//  SleepDebtWatcher
//
//  Created by Yohei Kato on 2018/01/07.
//  Copyright © 2018年 Yohei Kato. All rights reserved.
//

import Foundation
import UIKit
import Charts

class SleepDebtHistoryViewController: UIViewController {

    
    @IBOutlet weak var sleepDebtValueLabel: UILabel!
    var weekDay :Int = 0
    var sleepDebt:[Double] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    let highLimitTime = 4.0
    let midLimitTime = 2.0

    @IBOutlet weak var barDebtChartView: BarChartView!

    @IBAction func resetSleepDebtEvent(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(0.0, forKey: "sleepDebt")
        for i in 0..<sleepDebt.count {
            userDefaults.set(0.0, forKey: "sleepDebt" + String(i))
            sleepDebt[i] = 0.0
        }
        loadView()
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleepDebtValueLabel.text = String(sleepDebt[weekDay])
        let userDefaults = UserDefaults.standard
        for i in 0..<sleepDebt.count {
            sleepDebt[i] = userDefaults.double(forKey: "sleepDebt" + String(i))
        }
        let Monday = 1
        rotate(input_data: &sleepDebt, shift: Monday)//Chart starts from Monday
        setChart(y: sleepDebt)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSleepDebt(weekday: Int, rv_sleepDebt: Double){
        sleepDebt[weekday] = rv_sleepDebt
    }
    
    func setWeekDay(rv_weekday: Int){
        weekDay = rv_weekday
    }
    
    func setChart(y: [Double]) {
        // y軸
        var dataEntries = [BarChartDataEntry]()
        
        for (i, val) in y.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: val)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "負債")
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatter()
        barDebtChartView.xAxis.labelCount = Calendar.current.weekdaySymbols.count
        barDebtChartView.xAxis.valueFormatter = xaxis.valueFormatter
        barDebtChartView.data = BarChartData(dataSet: chartDataSet)
        barDebtChartView.xAxis.labelPosition = .bottom
        barDebtChartView.leftAxis.enabled = true
        barDebtChartView.leftAxis.labelCount = Int(4)
        barDebtChartView.pinchZoomEnabled = false
        barDebtChartView.rightAxis.enabled = false
        barDebtChartView.drawGridBackgroundEnabled = false
        barDebtChartView.chartDescription?.enabled = false
        
        let midLimitLine = ChartLimitLine(limit: midLimitTime, label: "注意水準")
        barDebtChartView.leftAxis.addLimitLine(midLimitLine)
        let highLimitLine = ChartLimitLine(limit: highLimitTime, label: "危険水準")
        barDebtChartView.leftAxis.addLimitLine(highLimitLine)
        
        chartDataSet.colors = [setColor(value: y[0]),setColor(value: y[1]),setColor(value: y[2]),setColor(value: y[3]),setColor(value: y[4]),setColor(value: y[5]),setColor(value: y[6])]
        
        barDebtChartView.backgroundColor = UIColor.white
        barDebtChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func setColor(value: Double) -> UIColor{
        if(value < midLimitTime){ return UIColor.green }
        else if(value <= highLimitTime && value >= midLimitTime){ return UIColor.yellow }
        else if(value > highLimitTime){ return UIColor.red }
        else { return UIColor.black }
    }
    
    
    func rotate(input_data: inout [Double], shift: Int ){
        var corrected_shift = shift
        while(corrected_shift < 0){
            corrected_shift = shift + input_data.count
        }
        while(corrected_shift >= input_data.count){
            corrected_shift = shift - input_data.count
        }
        if(corrected_shift == 0){
            
        }
        else {
            reverse(input_data: &input_data, rv_start: 0, rv_end: corrected_shift - 1)
            reverse(input_data: &input_data, rv_start: corrected_shift, rv_end: input_data.count - 1)
            reverse(input_data: &input_data, rv_start: 0, rv_end: input_data.count - 1)
        }
    }
    
    func reverse(input_data: inout [Double], rv_start: Int, rv_end: Int){
        var start = rv_start
        var end = rv_end
        while(start < end){
            swap(input_data: &input_data, index1: start, index2: end)
            start = start + 1
            end = end - 1
        }
    }
    
    func swap(input_data: inout [Double], index1: Int, index2: Int){
        var buf: Double = 0.0
        buf = input_data[index1]
        input_data[index1] = input_data[index2]
        input_data[index2] = buf
    }
    
    public class BarChartFormatter: NSObject, IAxisValueFormatter{
        var weeks: [String]! = ["月","火","水","木","金","土","日"]
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // 0 -> 月, 1 -> 火...
            return weeks[Int(value)]
        }
    }
    //Merged

}
