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
		Ring.startAnimatingWithImages(in: NSMakeRange(0, 50), duration: 2, repeatCount: 1)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
