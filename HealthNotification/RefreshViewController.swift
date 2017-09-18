//
//  RefreshViewController.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/09/17.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit

class RefreshViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var table: UITableView!
    
    let refreshArray: NSArray = ["外に出る", "首肩腕ストレッチ", "肩甲骨ストレッチ", "腰・アキレス腱ストレッチ"]
    
    @IBAction func endEvent(_ sender: Any) {
        updateStatistics()
        performSegue(withIdentifier: "refreshchart",sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        resetIsRefreshDone()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func resetIsRefreshDone(){
        for i in 0..<RefreshId.count {
            refreshCheckResult[i].isRefreshDone = false
        }
    }
    
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RefreshId.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell",
                                                     for: indexPath)
            cell.accessoryType = UITableViewCellAccessoryType.none
            let label = table.viewWithTag(1) as! UILabel
            label.text = "\(refreshArray[indexPath.row])"
            return cell
    }
    
    
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at:indexPath)
        
        if cell?.accessoryType == UITableViewCellAccessoryType.none {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            refreshCheckResult[indexPath.row].isRefreshDone = true
        }
        else {
            cell?.accessoryType = UITableViewCellAccessoryType.none
            refreshCheckResult[indexPath.row].isRefreshDone = false
        }
    }
    
    func updateStatistics(){
        for i in (0..<RefreshId.count){
            if(refreshCheckResult[i].isRefreshDone){
                refreshCheckResult[i].freq += 1.0
            }
        }
    }
    

}
