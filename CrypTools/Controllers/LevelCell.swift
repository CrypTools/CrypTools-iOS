//
//  LevelCell.swift
//  CrypTools
//
//  Created by Arthur Guiot on 13/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class LevelCell: UITableViewCell {

	@IBOutlet weak var LevelIndex: NumberLabel!
	@IBOutlet weak var LevelName: NumberLabel!
	@IBOutlet weak var Done: UIImageView!
	
	func renderLevelCell(fancy: String, index: Int, hidden: Bool) {
		LevelIndex.text = "#\(index + 1)"
		LevelName.text = fancy
		Done.isHidden = hidden
	}
}
