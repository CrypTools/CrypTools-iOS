//
//  WelcomeText.swift
//  CrypTools
//
//  Created by Arthur Guiot on 02/06/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class WelcomeText: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let appGroupID = "group.com.ArthurG.CrypTools"
        let defaults = UserDefaults(suiteName: appGroupID)
        
        defaults?.setValue("true", forKey: "welcome")
        defaults?.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
