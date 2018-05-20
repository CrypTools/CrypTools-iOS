//
//  LevelController.swift
//  CrypTools
//
//  Created by Arthur Guiot on 14/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import WebKit
import Down
import Alamofire
import WatchConnectivity

class LevelController: UIViewController, WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		
	}
	
	
	@IBOutlet weak var Loading: UIActivityIndicatorView!
	@IBOutlet weak var MarkDownView: UITextView!
	@IBOutlet weak var Answer: UITextField!
	
	var level: Level = Level(id: "", fancy: "", questionURL: "", answer: "");
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		GoogleReporter.shared.screenView("Level - \(level.id)")
		
		renderMarkDown()
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func renderMarkDown() {
		Alamofire.request(self.level.questionURL).response {
			response in
			if (response.error != nil) {
				Zingle.init(duration: 0.5, delay: 2)
					.message(message: "No internet connection!")
					.messageColor(color: .white)
					.backgroundColor(color: UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0))
					.show()
			}
			let markdown = String(data: response.data!, encoding: .utf8)
			let down = Down(markdownString: markdown!)
			let html = try? down.toAttributedString()
			self.MarkDownView.attributedText = html!
			
			self.Loading.isHidden = true
			
		}
	}
	@IBAction func textChanged(_ sender: Any) {
		checkAnswer()
	}
	func checkAnswer() {
		let trueAns = level.answer
		let guess = Answer.text
		if trueAns == guess {
			let appGroupID = "group.arthur_guiot.CrypTools"
			let defaults = UserDefaults(suiteName: appGroupID)
			var doneArray = defaults?.array(forKey: "done")
			doneArray?.append(self.level.id)
			defaults?.setValue(doneArray, forKey: "done")
			
			self.AppleWatchPush()
			
			performSegue(withIdentifier: "GoodAnswer", sender: self)
		}
	}
	@IBAction func back(_ sender: Any) {
		print("Going back")
		performSegue(withIdentifier: "BackLevel", sender: sender)
	}
	
	func AppleWatchPush() {
		let appGroupID = "group.arthur_guiot.CrypTools"
		let defaults = UserDefaults(suiteName: appGroupID)
		
		if WCSession.isSupported() { //makes sure it's not an iPad or iPod
			let watchSession = WCSession.default
			watchSession.delegate = self as WCSessionDelegate
			watchSession.activate()
			if watchSession.isPaired && watchSession.isWatchAppInstalled {
				do {
					try watchSession.updateApplicationContext([
						"done": defaults?.array(forKey: "done") ?? [],
						"levels": defaults?.integer(forKey: "levels") ?? 1
						])
				} catch let error as NSError {
					print(error.description)
				}
			}
		}
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y == 0{
				self.view.frame.origin.y -= keyboardSize.height
			}
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if self.view.frame.origin.y != 0{
				self.view.frame.origin.y += keyboardSize.height
			}
		}
	}
	@IBAction func share(_ sender: UIButton) {
		let url = NSURL(string: "https://cryptools.github.io/learn#\(level.id)")!
		let toShare = [
			url
		]
		let shareVC = UIActivityViewController(activityItems: toShare , applicationActivities: nil)
		
		shareVC.popoverPresentationController?.sourceView = sender
		self.present(shareVC, animated: true, completion: nil)
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
}
