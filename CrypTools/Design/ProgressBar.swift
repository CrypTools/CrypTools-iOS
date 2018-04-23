//
//  ProgressBar.swift
//  CrypTools
//
//  Created by Arthur Guiot on 23/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class ProgressBar: UIProgressView {

	func Animate(duration: Double, value: Float) {
		
		setProgress(0.01, animated: true)
		
		UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
			self.setProgress(value, animated: true)
		}, completion: nil)
	}

}
