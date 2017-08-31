//
//  AssessmentViewController.swift
//  HealthNotification
//
//  Created by Yohei Kato on 2017/08/06.
//  Copyright © 2017年 Yohei Kato. All rights reserved.
//

import UIKit
import CoreGraphics

class CBTViewController: UIViewController {
    var stressLevel: StressSignLevel = StressSignLevel.Strong
    var stressIdList: [Int] = []
    var isViewFromTop: Bool = true
    var resource: String = "CBT0"
    
    @IBAction func backEvent(_ sender: Any) {
        if(isViewFromTop){
            performSegue(withIdentifier: "top",sender: nil)
        }
        else{
            performSegue(withIdentifier: "stressCoping",sender: nil)
        }
    }
    
    var documentInteractionController: UIDocumentInteractionController?
    
    @IBAction func printEvent(_ sender: Any) {
        if let path: String = Bundle.main.path(forResource: resource, ofType: "pdf"){
            let url = NSURL(fileURLWithPath: path as String)
            documentInteractionController = UIDocumentInteractionController(url: url as URL)
            documentInteractionController?.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
        }
    }
    
    @IBOutlet weak var myWebView: UIWebView!
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "stressCoping"){
            let viewController: CopingViewController = (segue.destination as? CopingViewController)!
            viewController.stressLevel = stressLevel
            for(_, element) in stressIdList.enumerated(){
                viewController.stressIdList.append(element)
            }
        }
    }

    @IBAction func assessmentEvent(_ sender: Any) {
        loadCBTView(resource: "CBT0")
    }

    @IBAction func cognitiveReconstructionEvent(_ sender: Any) {
        loadCBTView(resource: "CBT1")
        
    }
    
    @IBAction func problemResolvementEvent(_ sender: Any) {
        loadCBTView(resource: "CBT2")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(myWebView)
        loadCBTView(resource: self.resource)

    }
    
    private func loadCBTView(resource :String){
        self.resource = resource
        if let path: String = Bundle.main.path(forResource: resource, ofType: "pdf"){
            let url = NSURL(fileURLWithPath: path as String)
            let request = NSURLRequest(url: url as URL)
            myWebView.loadRequest(request as URLRequest)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
