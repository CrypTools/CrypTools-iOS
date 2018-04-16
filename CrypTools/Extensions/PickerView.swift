//
//  PickerView.swift
//  CrypTools
//
//  Created by Arthur Guiot on 16/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

extension EncryptController: UIPickerViewDelegate, UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.ciphers.name.count
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.ciphers.name[row]
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.selected = self.ciphers.name[row]
		
		self.Input.text = ""
		
		self.render()
	}
}
