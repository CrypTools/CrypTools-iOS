//
//  b64.swift
//  CrypTools
//
//  Created by Arthur Guiot on 09/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

/******************************
 Use: "Hello".encrypt
 => "SGVsbG8="
 "SGVsbG8=".decrypt
 => "Hello"
 ******************************/

import Foundation

extension String {
    /// Encode a String to Base64
    var b64encrypt: String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Decode a String from Base64. Returns nil if unsuccessful.
    var b64decrypt: String? {
        guard let data = Data(base64Encoded: self) else {
            return "Error!"
        }
        return String(data: data, encoding: .utf8)
    }
}
