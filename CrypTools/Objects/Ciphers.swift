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
	func add(_ name: String, _ callback: (_ text: String, _ key: String) -> String) {
		self.name.append(name)
		self.call.append(callback)
	}
	func get(_ name: String) -> f {
		let i = self.name.index(of: name)
		return call[i!] as! f
	}
	init() {
		self.add("Caesar - Encrypt", {
			text, key in
			return text.CaesarEncrypt(Int(key))
		})
		self.add("Caesar - Decrypt", {
			text, key in
			return text.CaesarDecrypt(Int(key))
		})
		self.add("Base64 - Encrypt", {
			text, key in
			return text.b64encrypt
		})
		self.add("Base64 - Decrypt", {
			text, key in
			return text.b64decrypt!
		})
		self.add("BitShift - Encrypt", {
			text, key in
			return text.BitShiftEncrypt(key)
		})
		self.add("BitShift - Decrypt", {
			text, key in
			return text.BitShiftDecrypt(key)
		})
		self.add("Emoji - Encrypt", {
			text, key in
			return text.EmojiEncrypt
		})
		self.add("Emoji - Decrypt", {
			text, key in
			return text.EmojiDecrypt
		})
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
		})
		self.add("ROT13", {
			text, key in
			return text.rot13
		})
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
		})
	}
}
