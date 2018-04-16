//
//  EncryptController.swift
//  CrypTools
//
//  Created by Arthur Guiot on 16/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit

class EncryptController: UIViewController, UITextViewDelegate {
	
	@IBOutlet weak var Input: UITextView!
	@IBOutlet weak var Picker: UIPickerView!
	@IBOutlet weak var Output: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		Input.delegate = self //Without setting the delegate you won't be able to track UITextView events
		Picker.delegate = self
		
		self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func textViewDidChange(_ textView: UITextView) {
		render()
	}
	
	var ciphers = Cipher()
	var selected: String? = ""
	func render() {
		
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	func hideKeyboardWhenTappedAround() {
		let tapGesture = UITapGestureRecognizer(target: self,
												action: #selector(hideKeyboard))
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc func hideKeyboard() {
		view.endEditing(true)
	}
	
}
