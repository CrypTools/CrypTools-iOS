//
//  TodayViewController.swift
//  Widget
//
//  Created by Arthur Guiot on 24/05/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        let appGroupID = "group.com.ArthurG.CrypTools"
        let defaults = UserDefaults(suiteName: appGroupID)
        defaults?.synchronize()
        
        self.defaults()
       
        let nDone = Float((defaults?.array(forKey: "done")?.count)!)
        let nLevels = Float((defaults?.integer(forKey: "levels"))!)
        
        
        let progress = round((nDone / nLevels) * 100)
        label.text = "You've completed \(progress)% of the levels. \n \(Int(nLevels - nDone)) left"
    }
    func defaults() {
        let appGroupID = "group.com.ArthurG.CrypTools"
        let defaults = UserDefaults(suiteName: appGroupID)
        if (defaults?.array(forKey: "done") == nil) {
            defaults?.setValue([], forKey: "done")
            defaults?.setValue(1, forKey: "levels")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
