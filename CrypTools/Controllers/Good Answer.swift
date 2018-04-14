//
//  Good Answer.swift
//  CrypTools
//
//  Created by Arthur Guiot on 14/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class Good_Answer: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	@IBAction func back(_ sender: Any) {
		performSegue(withIdentifier: "GoodAnswer", sender: sender)
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
