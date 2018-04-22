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
	@IBOutlet weak var Key: UITextField!
	@IBOutlet weak var Placeholder: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		GoogleReporter.shared.screenView("Try")
		
		
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
		if Input.text == "" {
			Placeholder.isHidden = false
		} else {
			Placeholder.isHidden = true
		}
	}
	@IBAction func Render(_ sender: Any) {
		render()
	}
	
	var ciphers = Cipher()
	var selected: String? = Cipher().name[0]
	func render() {
		let fe = ciphers.get(self.selected)
		var out = ""
		do {
			out = try fe(Input.text, Key.text ?? "")
		} catch {
			out = "Error!"
		}
		Output.text = out
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
	
	
	@IBAction func Back(_ sender: UIButton) {
		performSegue(withIdentifier: "EncryptBack", sender: sender)
	}
	
	@IBAction func share(_ sender: UIButton) {
		render()
		
		let text = """
		---------- \(selected ?? ciphers.name[0]) ----------
		\(Output.text!)
		---------- \(Key.text ?? "No Key") ----------
		"""
		let toShare = [
			text
		]
		let shareVC = UIActivityViewController(activityItems: toShare , applicationActivities: nil)
		
		shareVC.popoverPresentationController?.sourceView = sender
		self.present(shareVC, animated: true, completion: nil)
	}
}
