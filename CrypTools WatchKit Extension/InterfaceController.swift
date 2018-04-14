//
//  InterfaceController.swift
//  CrypTools WatchKit Extension
//
//  Created by Arthur Guiot on 13/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

	@IBOutlet var Ring: WKInterfaceImage!
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		Ring.setImageNamed("")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		self.defaults()
		
		let appGroupID = "group.com.arguiot.CrypTools"
		let defaults = UserDefaults(suiteName: appGroupID)
		let array = defaults?.array(forKey: "done")
		let count: Float = (defaults?.float(forKey: "levels"))!
		let range = roundf((Float(array?.count ?? 0) / count) * 100)
		Ring.startAnimatingWithImages(in: NSMakeRange(0, Int(range) + 1), duration: 1.5, repeatCount: 1)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	func defaults() {
		let appGroupID = "group.com.arguiot.CrypTools"
		let defaults = UserDefaults(suiteName: appGroupID)
		if (defaults?.array(forKey: "done") == nil) {
			defaults?.setValue([], forKey: "done")
			defaults?.setValue(1, forKey: "levels")
		}
	}
}
