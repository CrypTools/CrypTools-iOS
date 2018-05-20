//
//  BitShift.swift
//  CrypTools
//
//  Created by Arthur Guiot on 10/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

/*********************************
 Use: "Hello World!".encrypt("key")
 "Hello World!".encrypt("key").decrypt("key")
 *********************************/
import Foundation

// Get array of ascii values from string
extension String {
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
}
extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}

extension String {
    func BitShiftEncrypt(_ keyValue: String) -> String {
        let encoded = self.asciiArray
        var keyEncoded = keyValue.asciiArray
        
        let array = encoded.map({
            x -> (UInt32) in
            var y = x
            for i in keyEncoded {
                y = (y + 1) << (i % 8)
            }
            keyEncoded = keyEncoded.reversed()
            return y;
        })
        return array.description.b64encrypt
    }
    func BitShiftDecrypt(_ keyValue: String) -> String {
        let toString = self.b64decrypt

        let chars = CharacterSet(charactersIn: ",][ ")
        let encoded = toString?.components(separatedBy: chars).filter {$0 != ""}.compactMap { UInt32($0)}
        var keyEncoded = keyValue.asciiArray
        var array = [UInt32]()
        for i in encoded! {
            keyEncoded = keyEncoded.reversed()
            var y = UInt32(i)
            for i in keyEncoded {
                y = (y - 1) >> (i % 8)
            }
            array.append(y)
        }
        var output = "";
        for i in array {
            output += String(UnicodeScalar(UInt8(i)))
        }
        return output
    }
}
