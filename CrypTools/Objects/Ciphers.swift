//
//  Ciphers.swift
//  CrypTools
//
//  Created by Arthur Guiot on 16/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import Foundation

typealias f = (_ text: String, _ key: String) -> String
class Cipher {
	var name = [String]()
	var call = [Any]()
	var type = [Bool]() // true is encrypt, false is decrypt
    func add(_ name: String, _ callback: f?, _ type: Bool = true) {
		self.name.append(name)
        self.call.append(callback)
		self.type.append(type)
	}
	func get(_ name: String?) -> f {
		let i = self.name.index(of: name ?? self.name[0])
		return call[i ?? 0] as! f
	}
	func getDecrypt(_ name: String) -> f {
		let match = matches(for: "Encrypt", in: name)
		if match.count > 0 {
			let i = self.name.index(of: name) ?? 0
			return call[i + 1] as! f
		} else {
			let i = self.name.index(of: name)
			return call[i ?? 0] as! f
		}
		
	}
	init() {
		self.add("Caesar - Encrypt", {
			text, key in
			return text.CaesarEncrypt(Int(key))
		})
		self.add("Caesar - Decrypt", {
			text, key in
			return text.CaesarDecrypt(Int(key))
		}, false)
		self.add("Base64 - Encrypt", {
			text, key in
			return text.b64encrypt
		})
		self.add("Base64 - Decrypt", {
			text, key in
			return text.b64decrypt!
		}, false)
		self.add("BinASCII - Encrypt", {
			text, key in
			return text.BinEncrypt
		})
		self.add("BinASCII - Decrypt", {
			text, key in
			return text.BinDecrypt
		}, false)
		self.add("BitShift - Encrypt", {
			text, key in
			return text.BitShiftEncrypt(key)
		})
		self.add("BitShift - Decrypt", {
			text, key in
			return text.BitShiftDecrypt(key)
		}, false)
		self.add("Emoji - Encrypt", {
			text, key in
			return text.EmojiEncrypt
		})
		self.add("Emoji - Decrypt", {
			text, key in
			return text.EmojiDecrypt
		}, false)
		self.add("HashShift - Encrypt", {
			text, key in
			return text.HashShiftEncrypt(Int(key) ?? 0)
		})
		self.add("HashShift - Decrypt", {
			text, key in
			return text.HashShiftDecrypt(Int(key) ?? 0)
		}, false)
		self.add("MD5", {
			text, key in
			return text.md5
		})
		self.add("Rail Fence - Encrypt", {
			text, key in
			return text.RailEncrypt(Int(key) ?? 3)
		})
		self.add("Rail Fence - Decrypt", {
			text, key in
			return text.RailDecrypt(Int(key) ?? 3)
		}, false)
		self.add("ROT13", {
			text, key in
			return text.rot13
		}, false)
		self.add("SHA256", {
			text, key in
			return text.sha256
		})
		self.add("XOR - Encrypt", {
			text, key in
			return text.XOREncrypt([Int(key) ?? 2])
		})
		self.add("XOR - Decrypt", {
			text, key in
			return text.XORDecrypt([Int(key) ?? 2])
		}, false)
	}
	
	
	private func matches(for regex: String, in text: String) -> [String] {
		
		do {
			let regex = try NSRegularExpression(pattern: regex)
			let results = regex.matches(in: text,
										range: NSRange(text.startIndex..., in: text))
			return results.map {
				String(text[Range($0.range, in: text)!])
			}
		} catch let error {
			print("invalid regex: \(error.localizedDescription)")
			return []
		}
	}
}
