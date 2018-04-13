//
//  Levels.swift
//  CrypTools
//
//  Created by Arthur Guiot on 13/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import Foundation

class Level {
	var id: String;
	var fancy: String;
	var questionURL: String;
	var answer: String;
	
	init(id: String, fancy: String, questionURL: String, answer: String) {
		self.id = id
		self.fancy = fancy
		self.questionURL = "https://cryptools.github.io/learn/noob_questions/\(questionURL)"
		self.answer = answer
	}
}
