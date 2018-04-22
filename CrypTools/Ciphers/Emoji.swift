//
//  Emoji.swift
//  CrypTools
//
//  Created by Arthur Guiot on 10/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

/*********************************
 *
 * Use: "message".encrypt
 * => "😝😅😒😒😄😍😅"
 *      "😝😅😒😒😄😍😅".decrypt
 * => "MESSAGE"
 *
 *********************************/
import Foundation

extension String {
    var EmojiEncrypt : String {
        let emojis = "😄,😃,😀,😊,😅,😉,😍,😘,😚,😗,😙,😜,😝,😛,😳,😁,😔,😌,😒,😞,😣,😢,😂,😭,😎,😈".components(separatedBy: ",")
        let lettersArray = [ "A",
                             "B",
                             "C",
                             "D",
                             "E",
                             "F",
                             "G",
                             "H",
                             "I",
                             "J",
                             "K",
                             "L",
                             "M",
                             "N",
                             "O",
                             "P",
                             "Q",
                             "R",
                             "S",
                             "T",
                             "U",
                             "V",
                             "W",
                             "X",
                             "Y",
                             "Z" ]
        var out = ""
        for i in self.uppercased() {
			let index = lettersArray.index(of: String(i))
			if index == nil {
				out += String(i)
			} else {
				out += emojis[index!]
			}
        }
        return out
    }
    var EmojiDecrypt : String {
        let emojis = "😄,😃,😀,😊,😅,😉,😍,😘,😚,😗,😙,😜,😝,😛,😳,😁,😔,😌,😒,😞,😣,😢,😂,😭,😎,😈".components(separatedBy: ",")
        let lettersArray = [ "A",
                             "B",
                             "C",
                             "D",
                             "E",
                             "F",
                             "G",
                             "H",
                             "I",
                             "J",
                             "K",
                             "L",
                             "M",
                             "N",
                             "O",
                             "P",
                             "Q",
                             "R",
                             "S",
                             "T",
                             "U",
                             "V",
                             "W",
                             "X",
                             "Y",
                             "Z" ]
        var out = ""
        for i in self.uppercased() {
			let index = emojis.index(of: String(i))
			if index == nil {
				out += String(i)
			} else {
				out += lettersArray[index!]
			}
        }
        return out
    }
}
