//
//  ConfigViewController.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/08/02.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit
import UserNotifications

class ConfigViewController: UIViewController, UNUserNotificationCenterDelegate, UIPickerViewDelegate,  UITableViewDataSource, UITableViewDelegate {
    
    enum NotificationFrequency :Int{
        case Everyday = 0
        case Everyweek
        case Onetime
    }
    
    let notificationFrequencyList: NSArray = ["毎日", "毎週","１回だけ"]
    
    var notificationFrequency : NotificationFrequency = .Everyday
    var changeddate : DateComponents!
    @IBAction func changeDate(_ sender: UIDatePicker) {
        changeddate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sender.date)
    }

    @IBOutlet var table: UITableView!

    @IBAction func TouchButton(sender: AnyObject) {
        var trigger: UNNotificationTrigger
        switch notificationFrequency {
        case .Everyday:
            let dateComponents = DateComponents(hour: changeddate.hour, minute: changeddate.minute)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        case .Everyweek:
            let dateComponents = DateComponents(hour: changeddate.hour ,minute: changeddate.minute, weekday: changeddate.weekday)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            break
        case .Onetime:
            trigger = UNCalendarNotificationTrigger(dateMatching: changeddate, repeats: false)
        }
        let content = UNMutableNotificationContent()
        content.title = "ストレスサインチェック"
        content.body = "該当するサインをタップして下さい」"
        content.sound = UNNotificationSound.default()
        
        // デフォルトの通知。画像などは設定しない
        let request = UNNotificationRequest(identifier: "normal", content: content, trigger: trigger)
        
        //通知を予約
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        performSegue(withIdentifier: "top", sender: nil)
    }
    
    @IBAction func backEvent(_ sender: Any) {
        performSegue(withIdentifier: "top", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.allowsMultipleSelection = false
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                if granted {
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                }
            })
        }
    }
    
    
    //To display notifications when app is running  inforeground
    private func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        willPresent notification: UNNotification,
                                        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        let identifier = notification.request.identifier
        switch identifier {
        case "alert":
            completionHandler([.alert]) // 通知のみ行う
        case "both":
            completionHandler([.sound, .alert]) // サウンドと通知
        default:
            ()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationFrequencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.none
            let label = table.viewWithTag(1) as! UILabel
            label.text = "\(notificationFrequencyList[indexPath.row])"
            let userDefaults = UserDefaults.standard
            let value: Int? = userDefaults.integer(forKey: "notifFreq")
            if(value == nil){
                setCellAccessoryType(accessoryType: &cell.accessoryType, row: indexPath.row, checkValue: notificationFrequency.rawValue)
            }
            else{
                setCellAccessoryType(accessoryType: &cell.accessoryType, row: indexPath.row, checkValue: value!)
            }
            return cell
    }
    
    
    private func setCellAccessoryType(accessoryType: inout UITableViewCellAccessoryType, row: Int, checkValue:Int) {
        if(row == checkValue){
            accessoryType = .checkmark
        }
        else {
            accessoryType = .none
        }
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at:indexPath)
        cell?.accessoryType = .checkmark
        notificationFrequency = ConfigViewController.NotificationFrequency(rawValue: indexPath.row)!
        let userDefaults = UserDefaults.standard
        userDefaults.set(indexPath.row, forKey: "notifFreq")
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
    }
}
