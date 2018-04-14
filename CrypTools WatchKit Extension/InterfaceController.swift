//
//  InterfaceController.swift
//  CrypTools WatchKit Extension
//
//  Created by Arthur Guiot on 13/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		let context = session.applicationContext
		self.array = context["done"] as! [String]
		self.count = context["levels"] as! Int
	}
	

	@IBOutlet var Ring: WKInterfaceImage!
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		Ring.setImageNamed("")
		
		let watchSession = WCSession.default
		watchSession.delegate = self
		watchSession.activate()
    }
	var count: Int = 1
	var array: [String] = [""]
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		self.defaults()
		
		let fCount = Float(count)
		let range = roundf((Float(array.count) / fCount) * 100)
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
