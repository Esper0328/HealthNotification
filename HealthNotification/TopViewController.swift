//
//  TopViewController.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/08/05.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit

class TopViewController: UIViewController{

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
}
