//
//  ROT13.swift
//  CrypTools
//
//  Created by Arthur Guiot on 12/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

/**************************************
Rot 13 is reversible
Use: "Hello World".rot13
=> "Uryyb Jbeyq"
**************************************/
extension String {
	var rot13 : String {
		let lettersArray = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz")
		return self.reduce("", { result, letter in
			if let i = lettersArray.index(of: letter) {
				return result + String(lettersArray[i + 13])
			} else {
				return result + String(letter)
			}
		})
	}
}
