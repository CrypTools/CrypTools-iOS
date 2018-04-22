//
//  Parser.swift
//  iMessage
//
//  Created by Arthur Guiot on 21/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import Foundation

class Parser {
	var text: String;
	
	var valid: Bool = false
	init(_ text: String) {
		self.text = text;
		
		if validate() {
			self.valid = true
			
			self.cipher = getCipher()
			self.key = getKey()
			self.text = getText()
		}
	}
	
	var cipher: String = ""
	var key: String = ""
	var encoded: String = ""
	
	func validate() -> Bool {
		let regex = "^---------- .* ----------.*---------- .* ----------$"
		var matches: [String] = []
		do {
			let NSRegex = try NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
			let results = NSRegex.matches(in: text,
										  range: NSRange(text.startIndex..., in: text))
			matches =  results.map {
				String(self.text[Range($0.range, in: text)!])
			}
			
		} catch {
			print("Error!")
		}
		return matches.count > 0
	}
	
	func getCipher() -> String {
		let regex = "^---------- .* ----------"
		var matches: [String];
		do {
			let NSRegex = try NSRegularExpression(pattern: regex)
			let results = NSRegex.matches(in: text,
										range: NSRange(text.startIndex..., in: text))
			matches =  results.map {
				String(self.text[Range($0.range, in: text)!])
			}
			
		} catch {
			return "Error!"
		}
		let c = matches[0]
		let startIndex = c.index(c.startIndex, offsetBy: 11)
		let endIndex = c.index(c.endIndex, offsetBy: -12)
		let cipherName = c[startIndex...endIndex]
		return String(cipherName)
	}
	func getKey() -> String {
		let regex = "---------- .* ----------$"
		var matches: [String];
		do {
			let NSRegex = try NSRegularExpression(pattern: regex)
			let results = NSRegex.matches(in: text,
										  range: NSRange(text.startIndex..., in: text))
			matches =  results.map {
				String(self.text[Range($0.range, in: text)!])
			}
			
		} catch {
			return "Error!"
		}
		let c = matches[0]
		let startIndex = c.index(c.startIndex, offsetBy: 11)
		let endIndex = c.index(c.endIndex, offsetBy: -12)
		let keyName = c[startIndex...endIndex]
		return String(keyName)
	}
	func getText() -> String {
		let cipherLength = self.cipher.count + 23
		let keyLength = self.key.count + 23
		
		let startIndex = self.text.index(self.text.startIndex, offsetBy: cipherLength)
		let endIndex = self.text.index(self.text.endIndex, offsetBy: -keyLength)
		
		let EncodedText = self.text[startIndex...endIndex]
		return String(EncodedText)
	}
}
