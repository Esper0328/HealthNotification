//
//  StrongCopingView.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/07/24.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit
import MessageUI

class CopingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate{
    
    @IBOutlet var table:UITableView!
    @IBOutlet var button: UIButton!

    @IBOutlet weak var stressCopingTypeLabel: UILabel!
    @IBAction func finishEvent(sender: AnyObject) {
        updateStatistics()
        performSegue(withIdentifier: "top",sender: nil)
    }
    
    @IBAction func backEvent(_ sender: Any) {
        switch stressLevel {
        case .Strong:
            resetIsExistStressSign(level: .Strong)
        case .Mid:
            resetIsExistStressSign(level: .Mid)
        case .Weak:
            resetIsExistStressSign(level: .Weak)
        }
        performSegue(withIdentifier: "signview",sender: nil)
    }
    
    func resetIsExistStressSign(level: StressSignLevel){
        for i in (stressSignIndex[level]!.0)..<(stressSignIndex[level]!.1){
            stressCheckResult[i].isExistStress = false
        }
    }
    
    func updateStatistics(){
        for i in (strongSignStart..<weakSignEnd){
            if(stressCheckResult[i].isExistStress){
                stressCheckResult[i].freq += 1.0
            }
        }
    }
    
    enum CopingType: Int{
        case Common = 0
        case Individual
    }
    
    enum CommonCopingStrongType: Int{
        case Sickleave = 0
        case DoNothing
        case GoHospital
        case SleepLonger
        case CBT
    }
    
    enum CommonCopingMidType: Int{
        case SleepChcek = 0
        case Bath
        case SleepLonger
        case DietCheck
        case ConsultWithBoss
        case CBT
        case Counseling
        case ConsultWithOthers
        case Medicine
        case GoHospital
        case GoMassage
    }
    enum CommonCopingWeakType: Int{
        case Relaxation = 0
        case Refresh
        case Bath
        case Sleep
        case Assesment
        case Counseling
        case ConsultWithOthers
    }
    
    var stressLevel: StressSignLevel = StressSignLevel.Strong
    var stressIdList: [Int] = []
    
    let stressCopingLevelString: NSArray = ["コーピング:強", "コーピング:中", "コーピング:弱"]
    let sectionTitle: NSArray = ["共通", "個別"]
    var isViewFromMail: Bool = false
    
    let commonCopingArray: [NSArray] = [["休暇申請", "休息を取る・何もしない", "精神科に行く","8.5時間睡眠","認知行動療法"], ["睡眠を見直す", "40℃の風呂15分", "睡眠8.5時間", "食生活を見直す", "上司に業務負荷相談", "認知行動療法", "カウンセリング", "同僚・友人・パートナーに相談", "症状に応じた薬を飲む", "精神科に行く(TEL)", "マッサージに行く"], ["呼吸法・自律訓練法・瞑想","気分転換","40℃の風呂15分","7.5時間睡眠","状況整理・認知行動療法","カウンセリング","サポート資源に相談"]]
    
    let individualCopingArray: [[NSArray]] = [[["常備薬を飲む"],["サポート資源に相談"],["抗うつ薬を飲む"],["気力があれば認知行動療法"],[""]], [["食生活を見直す"], ["整腸剤・トイレに行く"], ["一時的に席から離れる・外に出る"], ["お昼休みに20分寝る"], ["フルニトラゼパム0.20mg","電子機器見ない","マッサージ器使用"], ["フルニトラゼパム0.20mg"],["抗うつ剤を飲む"],["要因を分析する"],["抗不安薬を飲む","セルフストレッチ・マッサージ","呼吸法・自律訓練法・瞑想","その場を離れ休憩"],["上司に言って早めに帰宅"],["筋弛緩剤","就寝２H前電子機器見ない"],["ミスを自分自身で責めない"],["相手を配慮し口頭で伝える"],["飲酒禁止＆食・酒生活を見直す"]], [["セルフマッサージ・ストレッチ", "就寝２H前電子機器見ない"],["外に出る・深呼吸・音楽を聴く"], ["甘いもの450kcal以内OK"], ["酒週３回以内OK"], ["リフレッシュ","グルグル思考になっていないか検討"]]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle("終了", for: .normal)
    }

    @IBAction func SendMailButton(_ sender: Any) {
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section] as? String
    }

    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        stressCopingTypeLabel.text = stressCopingLevelString[stressLevel.rawValue] as? String
        var count : Int = 0
        if section == CopingType.Common.rawValue {
            return commonCopingArray[stressLevel.rawValue].count
        }
        else if section == CopingType.Individual.rawValue {
            var isFirst: [Bool] = []
            for i in 0 ..< individualCopingArray[stressLevel.rawValue].count{
                isFirst.append(true)
                for (_, element) in stressIdList.enumerated(){
                    if(element == i) && isFirst[i] {
                        count += individualCopingArray[stressLevel.rawValue][i].count
                        isFirst[i] = false
                    }
                }
            }
            return count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell",
                                                    for: indexPath)
        let label = table.viewWithTag(1) as! UILabel
        if indexPath.section == CopingType.Common.rawValue {
            label.text = "\(commonCopingArray[stressLevel.rawValue][indexPath.row])"
        }
        else if indexPath.section == CopingType.Individual.rawValue {
            var copingArray : [String] = []
            var isFirst: [Bool] = []
            for i in 0 ..< individualCopingArray[stressLevel.rawValue].count{
                isFirst.append(true)
                for (_, element) in stressIdList.enumerated(){
                    if(element == i) && isFirst[i] {
                        for (_, element2) in individualCopingArray[stressLevel.rawValue][i].enumerated(){
                            copingArray.append(element2 as! String)
                        }
                        isFirst[i] = false
                    }
                }
            }
            label.text = "\(copingArray[indexPath.row])"
        }
        else{
        
        }
        return cell
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        if (((stressLevel == .Strong) && (indexPath.section == CopingType.Common.rawValue) && (indexPath.row == CommonCopingStrongType.GoHospital.rawValue))
            || ((stressLevel == .Mid) && (indexPath.section == CopingType.Common.rawValue) && (indexPath.row == CommonCopingMidType.GoHospital.rawValue))){
            let url = NSURL(string: "tel://0357783600")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL)
            }
            else {
                UIApplication.shared.openURL(url as URL)
            }
        }
        else if ((stressLevel == .Mid) && (indexPath.section == CopingType.Common.rawValue) && (indexPath.row == CommonCopingMidType.GoMassage.rawValue)){
            let url = NSURL(string: "https://mitsuraku.jp/salon/52/")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL)
            }
            else {
                UIApplication.shared.openURL(url as URL)
            }
        }
        else if (((stressLevel == .Weak) && (indexPath.section == CopingType.Common.rawValue) && (indexPath.row == CommonCopingWeakType.Assesment.rawValue)) || ((stressLevel == .Mid) && (indexPath.section == CopingType.Common.rawValue) && (indexPath.row == CommonCopingMidType.CBT.rawValue)) || ((stressLevel == .Strong) && (indexPath.section == CopingType.Common.rawValue) && (indexPath.row == CommonCopingStrongType.CBT.rawValue))
            
            ){
            performSegue(withIdentifier: "cbt",sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if(segue.identifier == "signview"){
            let viewController: SignViewController = (segue.destination as? SignViewController)!
            viewController.stressLevel = stressLevel
            viewController.isViewFromTop = false
        }
        else if (segue.identifier == "cbt"){
            let viewController: CBTViewController = (segue.destination as? CBTViewController)!
            viewController.stressLevel = stressLevel
            for(_, element) in stressIdList.enumerated(){
                viewController.stressIdList.append(element)
            }
            viewController.isViewFromTop = false
        }
    }
    

    
}

