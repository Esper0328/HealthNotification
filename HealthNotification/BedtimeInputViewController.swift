//
//  BedtimeInputViewController.swift
//  SleepDebtWatcher
//
//  Created by Yohei Kato on 2018/01/07.
//  Copyright © 2018年 Yohei Kato. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class BedtimeInputViewController: UIViewController {
    

    @IBOutlet weak var timeOfSleepLabel: UILabel!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var inputModeLabel: UILabel!
    @IBOutlet weak var wakeTimeLabel: UILabel!
    
    var changeddate : DateComponents!
    @IBAction func changeDate(_ sender: Any) {
        changeddate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: (sender as AnyObject).date)
    }
    
    enum SleepInputMode{
        case Plan
        case Result
    }
    
    enum SleepInputType{
        case TimeOfSleep
        case WakeTime
    }
    
    struct ModeParameter{
        var label: String = ""
        var datePickerMode: UIDatePickerMode
    }
    
    struct NotificationContents{
        var title: String = ""
        var body: String = ""
    }
    let planModeParameter = ModeParameter(label: "起床・就寝予定入力モード", datePickerMode: UIDatePickerMode.time)
    let resultModeParameter = ModeParameter(label: "起床・就寝結果入力モード", datePickerMode: UIDatePickerMode.dateAndTime)
    lazy var inputModeContents : [SleepInputMode : ModeParameter] = [.Plan: planModeParameter, .Result: resultModeParameter]
    
    let timeOfSleepNotificationContents = NotificationContents(title: "就寝予定２時間前", body:"そろそろ寝る時間です")
    let wakeTimeNotificationContents = NotificationContents(title: "起床時間", body:"Good Morining")
    lazy var notificationContents : [SleepInputType : NotificationContents] = [.TimeOfSleep: timeOfSleepNotificationContents, .WakeTime: wakeTimeNotificationContents]
    
    var timeOfSleep: DateComponents!
    var wakeTime: DateComponents!
    var bedtime: Double! = 0.0       //unit:[H]
    var sleepDebt: Double! = 0.0     //unit:[H]
    var sleepInputType: SleepInputType = .TimeOfSleep
    var sleepInputMode: SleepInputMode = .Plan
    var weekdayOfCalcBedtime : Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputModeLabel.text = inputModeContents[sleepInputMode]?.label
        datepicker.datePickerMode = (inputModeContents[sleepInputMode]?.datePickerMode)!
        let date = Date()
        datepicker.maximumDate = date
#if SIM //For fast SIM Test
#else   //iPhone
        datepicker.minimumDate = Calendar.current.date(byAdding: .day, value: -7, to: Calendar.current.startOfDay(for: date))
#endif
        timeOfSleepLabel.textColor = UIColor.blue
        wakeTimeLabel.textColor = UIColor.black
        let userDefaults = UserDefaults.standard
        sleepDebt = userDefaults.double(forKey: "sleepDebt")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTimeOfSleep(rv_timeOfSleep: DateComponents){
        timeOfSleep = rv_timeOfSleep
    }
    
    func setWakeTime(rv_wakeTime: DateComponents){
        wakeTime = rv_wakeTime
    }
    
    @IBAction func setBedtimeEvent(_ sender: Any) {
        switch sleepInputMode {
        case .Plan:
            let content = UNMutableNotificationContent()
            content.title = (notificationContents[sleepInputType]?.title)!
            content.body = (notificationContents[sleepInputType]?.body)!
            var dateComponents = DateComponents(hour: changeddate.hour, minute: changeddate.minute)
            switch sleepInputType {
            case .TimeOfSleep:
                timeOfSleep = changeddate
                dateComponents.hour = dateComponents.hour! - 2
                setNotification(dateComponents:dateComponents, content: content)
                sleepInputType = .WakeTime

                timeOfSleepLabel.textColor = UIColor.black
                wakeTimeLabel.textColor = UIColor.blue
            case .WakeTime:
                wakeTime = changeddate
                setNotification(dateComponents:dateComponents, content: content)
                performSegue(withIdentifier: "backToTopViewFromInput", sender: nil)
            }
        case .Result:
            switch sleepInputType {
            case .TimeOfSleep:
                timeOfSleep = changeddate
                sleepInputType = .WakeTime
                timeOfSleepLabel.textColor = UIColor.black
                wakeTimeLabel.textColor = UIColor.blue
            case .WakeTime:
                wakeTime = changeddate
                var comps = Calendar.current.dateComponents([.second], from: timeOfSleep, to: wakeTime)
                let threshold = Calendar.current.dateComponents([.second], from: timeOfSleep, to: timeOfSleep)
                if(comps.second! > threshold.second!){
                    calcSleepDebt()
                    performSegue(withIdentifier: "sleepDebtFromInput", sender: nil)
                }
                else{
                    loadView()
                    viewDidLoad()
                }
            }
        }
    }
    
    @IBAction func backToTopViewEvent(_ sender: Any) {
        performSegue(withIdentifier: "backToTopViewFromInput", sender: nil)
    }
    
    func isValidBedtime() -> Bool{
        let calendar = Calendar.current
        let dateFrom = calendar.date(from: timeOfSleep)!
        let dateTo = calendar.date(from: wakeTime)!
        let comps = calendar.dateComponents([.second], from: dateFrom, to: dateTo)
        return (comps.second! > 0)
    }
    
    func calcBedtime(){
        if(isValidBedtime()){
            let calendar = Calendar.current
            let dateFrom = calendar.date(from: timeOfSleep)!
            let dateTo = calendar.date(from: wakeTime)!
            let comps = calendar.dateComponents([.hour, .minute], from: dateFrom, to: dateTo)
            bedtime = Double(comps.hour!) + Double(comps.minute!)/60.0
            weekdayOfCalcBedtime = calendar.component(.weekday, from: dateTo)
        }
        else{
            bedtime = 0.0
            weekdayOfCalcBedtime = 0
        }
    }
    
    func calcSleepDebt(){
        calcBedtime()
        let sleepTimeThreshold = 8.0
        if(bedtime > 0){
            sleepDebt = sleepDebt + (sleepTimeThreshold - bedtime)
            if(sleepDebt < 0){
                sleepDebt = 0
            }
        }
    }
    
    func setSleepInputMode(mode:SleepInputMode){
        sleepInputMode = mode
    }
    
    func setNotification(dateComponents:DateComponents!, content:UNMutableNotificationContent){
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        content.sound = UNNotificationSound.default()
        let request = UNNotificationRequest(identifier: "normal", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "sleepDebtFromInput"){
            let viewController: SleepDebtHistoryViewController = (segue.destination as? SleepDebtHistoryViewController)!
            let weekdayFromZero = weekdayOfCalcBedtime % Calendar.current.weekdaySymbols.count
            viewController.setWeekDay(rv_weekday: weekdayFromZero)
            viewController.setSleepDebt(weekday: weekdayFromZero , rv_sleepDebt: sleepDebt)//from 1-7(from Apple spec of Weekday) to 0-6(for array index)
            let userDefaults = UserDefaults.standard
            userDefaults.set(sleepDebt, forKey: "sleepDebt")
            for i in 0..<7 {
                if(i == weekdayFromZero){
                    userDefaults.set(sleepDebt, forKey: "sleepDebt" + String(weekdayFromZero))
                }
            }
        }
    }
}
