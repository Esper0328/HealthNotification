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
    
    var stressLevel: StressSignLevel = StressSignLevel.Strong
    var stressIdList: [Int] = []
    
    let stressCopingLevelString: NSArray = ["コーピング:強", "コーピング:中", "コーピング:弱"]
    let sectionTitle: NSArray = ["共通", "個別"]
    
    let commonCopingArray: [NSArray] = [["上司に言って直ちに帰宅・通院(TEL)", "睡眠を取る", "何もしない"], ["40℃の風呂15分", "睡眠8.5時間", "上司に業務負荷相談", "認知行動療法・カウンセリング", "精神科に行く(TEL)"], ["アセスメント・状況整理"]]
    let individualCopingArray: [[NSArray]] = [[["なし"]], [["就寝15分前フルニトラゼパム1/4錠"], ["マッサージ"], ["抗不安薬"], ["自分を責めない"], ["美味しいものを食べる"], ["禁酒"], ["相手に配慮し必要に応じ口頭で対応"]], [["マッサージ・ストレッチ", "40℃の風呂15分", "睡眠８時間"],["外に出る,深呼吸"], ["甘いもの450kcal以内OK"], ["酒週３回以内OK"], ["リフレッシュ","グルグル思考になっていないか検討"]]]
    
    
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
        if section == 0 {
            return commonCopingArray[stressLevel.rawValue].count
        }
        else if section == 1 {
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
        if indexPath.section == 0 {
            label.text = "\(commonCopingArray[stressLevel.rawValue][indexPath.row])"
        }
        else if indexPath.section == 1 {
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
        if (((stressLevel == .Strong) && (indexPath.section == 0) && (indexPath.row == 0)) || ((stressLevel == .Mid) && (indexPath.section == 0) && (indexPath.row == 4))){
            let url = NSURL(string: "tel://0357783600")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL)
            }
            else {
                UIApplication.shared.openURL(url as URL)
            }
        }
        else if ((stressLevel == .Weak) && (indexPath.section == 0) && (indexPath.row == 0)){
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

        }
    }
    
}

