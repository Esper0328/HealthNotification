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

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "signview"){
            let viewController: SignViewController = (segue.destination as? SignViewController)!
            viewController.isViewFromTop = true
        }
    }
}
