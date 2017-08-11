//
//  StrongCopingView.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/07/24.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit

class CopingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet var table:UITableView!
    @IBOutlet var button: UIButton!

    @IBOutlet weak var stressCopingTypeLabel: UILabel!
    @IBAction func TouchButton(sender: AnyObject) {
        performSegue(withIdentifier: "top",sender: nil)
    }
    
    @IBAction func backEvent(_ sender: Any) {
        performSegue(withIdentifier: "signview",sender: nil)
    }
    
    
    enum CopingType: Int{
        case Common = 0
        case Individual
    }
    
    enum CommonCopingStrongType: Int{
        case GoHospital = 0
        case Sleep
        case DoNothing
    }
    
    enum CommonCopingMidType: Int{
        case BATH15minute = 0
        case SleepLonger
        case ConsultWithBoss
        case GoMassage
        case CBT
        case GoHospital
        case Assessment
    }
    enum CommonCopingWeakType: Int{
        case Assesment
        case AnalyzeFactor
    }
    
/*
    enum StrongStressSignId: Int{
        case Tears = 0
        case Jinmashin
        case Sucide
        case CannotDo
        case SlowWork
        case DoSame3more
    }
    
    enum MidStressSignId: Int{
        case ShallowSleep = 0
        case Vertigo
        case Irritated
        case Careless
        case BadLook
        case DrinkTooMuch
        case AvoidCommunication
    }
    
    enum WeakStressSignId: Int{
        case StiffShoulder = 0
        case Tension
        case EatSweets
        case Drink
        case DoSame3Less
    }
*/
    var stressLevel: StressSignLevel = StressSignLevel.Strong
    var stressIdList: [Int] = []
    
    let stressCopingLevelString: NSArray = ["コーピング:強", "コーピング:中", "コーピング:弱"]
    let sectionTitle: NSArray = ["共通", "個別"]
    
    let commonCopingArray: [NSArray] = [["上司に言って直ちに帰宅・通院(TEL)", "睡眠を取る", "何もしない"], ["40℃の風呂15分", "睡眠8.5時間", "上司に業務負荷相談", "マッサージに行く", "認知行動療法・カウンセリング", "精神科に行く(TEL)"], ["アセスメント","ストレス要因分析"]]
    
    let individualCopingArray: [[NSArray]] = [[["なし"]], [["就寝15分前フルニトラゼパム1/4錠"], ["抗不安薬"], ["自分を責めない"], ["美味しいものを食べる"], ["禁酒"], ["相手に配慮し必要に応じ口頭で対応"]], [["セルフマッサージ・ストレッチ", "40℃の風呂15分", "睡眠８時間"],["外に出る,深呼吸"], ["甘いもの450kcal以内OK"], ["酒週３回以内OK"], ["リフレッシュ","グルグル思考になっていないか検討"]]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        else if ((stressLevel == .Weak) && (indexPath.section == CopingType.Common.rawValue) && (indexPath.row == CommonCopingWeakType.Assesment.rawValue)){
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

