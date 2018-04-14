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

class LevelController: UIViewController {
	
	@IBOutlet weak var Loading: UIActivityIndicatorView!
	@IBOutlet weak var MarkDownView: UITextView!
	@IBOutlet weak var Answer: UITextField!
	
	var level: Level = Level(id: "", fancy: "", questionURL: "", answer: "");
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		renderMarkDown()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func renderMarkDown() {
		Alamofire.request(self.level.questionURL).response {
			response in
			let markdown = String(data: response.data!, encoding: .utf8)
			let down = Down(markdownString: markdown!)
			let html = try? down.toAttributedString()
			self.MarkDownView.attributedText = html!
			
			self.Loading.isHidden = true
			
			let css = try? String(contentsOfFile: Bundle.main.path(forResource: "github-markdown", ofType: "css")!)
			print(css!.prefix(20))
			
		}
	}
	@IBAction func textChanged(_ sender: Any) {
		checkAnswer()
	}
	func checkAnswer() {
		let trueAns = level.answer
		let guess = Answer.text
		if trueAns == guess {
			let appGroupID = "group.com.arguiot.CrypTools"
			let defaults = UserDefaults(suiteName: appGroupID)
			var doneArray = defaults?.array(forKey: "done")
			doneArray?.append(self.level.id)
			defaults?.setValue(doneArray, forKey: "done")
			performSegue(withIdentifier: "GoodAnswer", sender: self)
		}
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
