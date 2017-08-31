//
//  StrongSignViewController.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/07/24.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit
import MessageUI

class SignViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var stressSignTypeLabel: UILabel!
    @IBOutlet var table:UITableView!
    @IBOutlet var button: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var sendbutton: UIButton!
    var stressLevel: StressSignLevel = .Strong
    var stressIdList: [Int] = []
    var isCopingNeeded: Bool = false
    var isViewFromTop: Bool = true
    
    @IBAction func nextEvent(sender: AnyObject) {
        if isCopingNeeded {
            performSegue(withIdentifier: "stressCoping",sender: nil)
        }
        else{
            switch stressLevel {
            case .Strong:
                stressLevel = .Mid
                backbutton.isEnabled = true
                isViewFromTop = false
            case .Mid:
                stressLevel = .Weak
                button.setTitle("終了", for: .normal)
                sendbutton.isEnabled = true
            case .Weak:
                performSegue(withIdentifier: "top",sender: nil)
            }
            table.reloadData()
        }
    }
    
    @IBAction func backEvent(_ sender: Any) {
        switch stressLevel {
        case .Strong:
            backbutton.isEnabled = false
            sendbutton.isEnabled = false
        case .Mid:
            stressLevel = .Strong
            backbutton.isEnabled = false
            sendbutton.isEnabled = false
            resetIsExistStressSign(level: .Strong)
        case .Weak:
            stressLevel = .Mid
            backbutton.isEnabled = true
            sendbutton.isEnabled = false
            resetIsExistStressSign(level: .Mid)
            if(isViewFromTop){
            
            }
            else{
                button.setTitle("次へ", for: .normal)
            }
        }
        table.reloadData()
    }
    
    @IBAction func sendMailEvent(_ sender: Any) {
        sendStressCheckResult()
    }
    
    func sendStressCheckResult(){
        if MFMailComposeViewController.canSendMail() {
            var bodyMessage: String = ""
            bodyMessage += addCheckResult(level: .Strong)
            bodyMessage += addCheckResult(level: .Mid)
            bodyMessage += addCheckResult(level: .Weak)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["esper0328@gmail.com"]) // 宛先アドレス
            mail.setSubject("ストレスチェック結果:" + dateString) // 件名
            mail.setMessageBody(bodyMessage, isHTML: false) // 本文
            present(mail, animated: true, completion: nil)
        } else {
            print("Cannot Send")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("キャンセル")
        case .saved:
            print("下書き保存")
        case .sent:
            print("送信成功")
            saveStressCheckResult()
        default:
            print("送信失敗")
            saveStressCheckResult()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func resetIsExistStressSign(level: StressSignLevel){
        for i in (stressSignIndex[level]!.0)..<(stressSignIndex[level]!.1){
            stressCheckResult[i].isExistStress = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch stressLevel {
        case .Strong:
            backbutton.isEnabled = false
            sendbutton.isEnabled = false
            resetIsExistStressSign(level: .Strong)
        case .Mid:
            backbutton.isEnabled = true
            sendbutton.isEnabled = false
            resetIsExistStressSign(level: .Mid)
        case .Weak:
            if(isViewFromTop){
                button.setTitle("次へ", for: .normal)
            }
            else {
                button.setTitle("終了", for: .normal)
                sendbutton.isEnabled = true
                resetIsExistStressSign(level: .Weak)
            }
            backbutton.isEnabled = true
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        stressSignTypeLabel.text = stressSignLevelString[stressLevel]
        return (stressSignList[stressLevel]?.count)!
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell",
                                                     for: indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.none
            let label = table.viewWithTag(1) as! UILabel
            label.text = stressSignString[(stressSignList[stressLevel]?[indexPath.row])!]
            return cell
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at:indexPath)

        if cell?.accessoryType == UITableViewCellAccessoryType.none {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            stressCheckResult[stressSignIndex[stressLevel]!.0 + indexPath.row].isExistStress = true
            var isNewId : Bool = true
            for(_, element) in stressIdList.enumerated(){
                if(element == indexPath.row){
                    isNewId = false
                }
            }
            if isNewId {
                stressIdList.append(indexPath.row)
            }
        }
        else {
            cell?.accessoryType = UITableViewCellAccessoryType.none
            stressCheckResult[stressSignIndex[stressLevel]!.0 + indexPath.count].isExistStress = false
        }
        isCopingNeeded = false
        
        for i in (stressSignIndex[stressLevel]!.0)..<(stressSignIndex[stressLevel]!.1){
            if stressCheckResult[i].isExistStress {
                isCopingNeeded = true
            }
        }
        
        if isCopingNeeded{
            button.setTitle("次へ", for: .normal)
        }
        else{
            switch stressLevel {
            case .Strong:
                break
            case .Mid:
                break
            case .Weak:
                button.setTitle("終了", for: .normal)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "stressCoping"){
            let viewController: CopingViewController = (segue.destination as? CopingViewController)!
            viewController.stressLevel = stressLevel
            for(_, element) in stressIdList.enumerated(){
                viewController.stressIdList.append(element)
            }
        }
    }
}

