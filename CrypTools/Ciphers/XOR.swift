//
//  XOR.swift
//  CrypTools
//
//  Created by Arthur Guiot on 11/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

/*********************************
 *
 * Use: "Hello World!".encrypt([134])
 * => "Îãêêé¦Ñéôêâ§"
 *      "U[êqQ¦JQôqZ§".decrypt([134])
 * => "Hello World!"
 *
 *********************************/
import Foundation

//ascii code
extension Character
{
    func unicodeValue() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}
// main
extension String {
    func XOREncrypt(_ keyValue: Array<Int>) -> String {
        var out = "";
        let inArray = Array(self);
        let keyArray = keyValue;
        let c = self.count
        if c > 1 {
            for i in 0...abs(c - 1) {
                let c = Int(inArray[i].unicodeValue())
                let k = Int(keyArray[i % keyValue.count])
                out += String(Character(UnicodeScalar(Int(c ^ k))!))
            }
        }
        return out
    }
    func XORDecrypt(_ keyValue: Array<Int>) -> String {
        return self.XOREncrypt(keyValue)
    }
}
