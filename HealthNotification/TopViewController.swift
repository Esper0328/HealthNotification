//
//  TopViewController.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/08/05.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit

class TopViewController: UIViewController{

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var stressCheckButton: UIButton!
    @IBOutlet weak var chartViewButton: UIButton!
    @IBOutlet weak var cbtButton: UIButton!
    @IBOutlet weak var inputBedtimeButton: UIButton!
    @IBOutlet weak var sleepDebtButton: UIButton!
    @IBOutlet weak var configButton: UIButton!
    
    @IBAction func stressCheckEvent(_ sender: Any) {
        performSegue(withIdentifier: "signview", sender: nil)
    }
    
    @IBAction func cbtEvent(_ sender: Any) {
        performSegue(withIdentifier: "cbt",sender: nil)
    }
    
    
    @IBAction func configEvent(_ sender: Any) {
        performSegue(withIdentifier: "config",sender: nil)
    }

    
    @IBAction func chartViewEvent(_ sender: Any) {
        performSegue(withIdentifier: "stresschart",sender: nil)
    }
    
    @IBAction func refreshEvent(_ sender: Any) {
        performSegue(withIdentifier: "refresh",sender: nil)
    }
    
    @IBAction func inputBedtimeEvent(_ sender: Any) {
        performSegue(withIdentifier: "inputBedtime",sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "signview"){
            let viewController: SignViewController = (segue.destination as? SignViewController)!
            viewController.isViewFromTop = true
        }
        else if(segue.identifier == "cbt"){
            let viewController: CBTViewController = (segue.destination as? CBTViewController)!
            viewController.isViewFromTop = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var isConfigFinished: Bool = false
        isConfigFinished = UserDefaults.standard.bool(forKey: "isConfigFinished")
        if isConfigFinished {
            refreshButton.isEnabled = true
            stressCheckButton.isEnabled = true
            chartViewButton.isEnabled = true
            cbtButton.isEnabled = true
            inputBedtimeButton.isEnabled = true
            sleepDebtButton.isEnabled = true
        }
        else{
            refreshButton.isEnabled = false
            stressCheckButton.isEnabled = false
            chartViewButton.isEnabled = false
            cbtButton.isEnabled = false
            inputBedtimeButton.isEnabled = false
            sleepDebtButton.isEnabled = false
        }
        configButton.isEnabled = true
    }
}
