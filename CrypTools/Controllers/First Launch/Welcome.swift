//
//  Welcome.swift
//  CrypTools
//
//  Created by Arthur Guiot on 02/06/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class Welcome: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var arrow: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let appGroupID = "group.com.ArthurG.CrypTools"
        let defaults = UserDefaults(suiteName: appGroupID)
        defaults?.synchronize()
        if defaults?.string(forKey: "welcome") == Optional("true") {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "skip", sender: self)
            }
        }
        
        let diff: CGFloat = 30
        label.alpha = 0
        label.center.y += diff
        
        arrow.alpha = 0
        arrow.center.y += diff
        UIView.animate(withDuration: 1, animations: {
            self.label.alpha = 1
            self.label.center.y -= diff
            
            self.arrow.alpha = 1
            self.arrow.center.y -= diff
        })
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
