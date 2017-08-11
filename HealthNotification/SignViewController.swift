//
//  StrongSignViewController.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/07/24.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit

enum StressSignLevel: Int {
    case Strong = 0
    case Mid
    case Weak
}

class SignViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var stressSignTypeLabel: UILabel!
    @IBOutlet var table:UITableView!
    @IBOutlet var button: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    var stressLevel: StressSignLevel = .Strong
    var stressIdList: [Int] = []
    var isCopingNeeded: Bool = false
    var isViewFromTop: Bool = true
    
    @IBAction func TouchButton(sender: AnyObject) {
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
        case .Mid:
            stressLevel = .Strong
            backbutton.isEnabled = true
        case .Weak:
            stressLevel = .Mid
            backbutton.isEnabled = true
            if(isViewFromTop){
            
            }
            else{
                button.setTitle("次へ", for: .normal)
            }
        }
        table.reloadData()
    }
    
    let stressSignLevelString: NSArray = ["ストレスサイン:強", "ストレスサイン:中", "ストレスサイン:弱"]
    let stressSignArray: [NSArray] = [["涙が出る", "蕁麻疹", "消えたくなる・死にたくなる", "何もできなくなる", "仕事が遅くなる", "同じことを３回以上繰返す"], ["入眠困難・浅い睡眠", "顔の張り・目眩","イライラ・しんどさ", "ケアレスミス・物忘れ１日３回以上", "無口になる・食欲減退・外見悪化","飲酒週に３回以上","苦手な人とのコミュニケーションを避ける"], ["首・肩・背中・腰・脹脛・足裏の疲れ", "緊張感", "甘いものを食べたくなる", "酒を飲みたくなる", "仕事のことを考え過ぎ・同じことを繰返す"]]
    var isStress: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (_, _)in stressSignArray[StressSignLevel.Mid.rawValue].enumerated(){
            //最大のストレスサイン配列の数だけ作成
            isStress.append(false)
        }
        switch stressLevel {
        case .Strong:
            backbutton.isEnabled = false
        case .Mid:
            backbutton.isEnabled = true
        case .Weak:
            if(isViewFromTop){
                button.setTitle("次へ", for: .normal)
            }
            else {
                button.setTitle("終了", for: .normal)
            }
            backbutton.isEnabled = true
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        stressSignTypeLabel.text = stressSignLevelString[stressLevel.rawValue] as? String
        return stressSignArray[stressLevel.rawValue].count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell",
                                                     for: indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.none
            let label = table.viewWithTag(1) as! UILabel
            label.text = "\(stressSignArray[stressLevel.rawValue][indexPath.row])"
            return cell
    }
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at:indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.none {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            isStress[indexPath.count] = true
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
            isStress[indexPath.count] = false
        }
        
        isCopingNeeded = false
        for (index, _)in stressSignArray[stressLevel.rawValue].enumerated(){
            if isStress[index] {
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

