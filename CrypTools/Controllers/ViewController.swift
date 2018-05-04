//
//  ViewController.swift
//  CrypTools
//
//  Created by Arthur Guiot on 13/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WatchConnectivity


class ViewController: UIViewController, UITextFieldDelegate, WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		
	}
	
	
	@IBOutlet weak var TableView: UITableView!
	@IBOutlet weak var Loading: UIActivityIndicatorView!
	@IBOutlet weak var LearnText: UILabel!
	@IBOutlet weak var NavBar: UINavigationItem!
	@IBOutlet weak var progressBar: ProgressBar!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		GoogleReporter.shared.screenView("Main")
		
		self.levels = [] // Emptying levels to make sure that the app is reloading each levels
		
		UIApplication.shared.statusBarStyle = .lightContent
		
		LearnText.isHidden = true
		
		defaults()
		
		TableView.delegate = self
		TableView.dataSource = self
		TableView.rowHeight = 300
		TableView.tableFooterView = UIView(frame: CGRect.zero)
		TableView.separatorStyle = .none
		
		getLevels()
		
		updateProgress()
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	func defaults() {
		let appGroupID = "group.com.arguiot.CrypTools"
		let defaults = UserDefaults(suiteName: appGroupID)
		if (defaults?.array(forKey: "done") == nil) {
			defaults?.setValue([], forKey: "done")
			defaults?.setValue(1, forKey: "levels")
		}
		
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
	var levels: [Level] = []
	func getLevels() {
		let location = "https://cryptools.github.io/learn/api/challenges.json"
		Alamofire.request(location).responseJSON {
			response in
			if (response.error != nil) {
				Zingle.init(duration: 0.5, delay: 2)
					.message(message: "No internet connection!")
					.messageColor(color: .white)
					.backgroundColor(color: UIColor(red:0.16, green:0.16, blue:0.16, alpha:1.0))
					.show()
			}
			do {
				let json = try JSON(data: response.data!)
				let noob = json["challenges"]["noob"]
				
				self.TableView.beginUpdates()
				var indexes: [IndexPath] = []
				for i in noob.arrayValue {
					self.levels.append(Level(id: i["name"].string!,
											 fancy: i["fancy"].string!,
											 questionURL: i["question"].string!,
											 answer: i["answer"].stringValue))
					indexes.append(IndexPath(row: self.levels.count - 1, section: 0))
				}
				self.TableView.insertRows(at: indexes, with: .automatic)
				self.TableView.endUpdates()
				
				self.Loading.isHidden = true
				self.LearnText.isHidden = false
				
				let appGroupID = "group.com.arguiot.CrypTools"
				let defaults = UserDefaults(suiteName: appGroupID)
				defaults?.setValue(self.levels.count, forKey: "levels")
				
				self.defaults()
			} catch {
				print("JSON Parsing Error")
			}
		}
	}
	
	func updateProgress() {
		let appGroupID = "group.com.arguiot.CrypTools"
		let defaults = UserDefaults(suiteName: appGroupID)
		
		let nDone = Float((defaults?.array(forKey: "done")?.count)!)
		let nLevels = Float((defaults?.integer(forKey: "levels"))!)
		
		let progress = nDone / nLevels
		progressBar.Animate(duration: 1.5, value: progress)
		
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let path = TableView.indexPathForSelectedRow {
			let row = path.row
			let LevelC = segue.destination as! LevelController
			LevelC.level = self.levels[row]
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return levels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let level = levels[indexPath.row]
		
		let appGroupID = "group.com.arguiot.CrypTools"
		let defaults = UserDefaults(suiteName: appGroupID)
		
		let done: [String] = defaults?.array(forKey: "done") as! [String]
		let hidden = done.contains(where: { $0 == level.id })
		
		let cell = TableView.dequeueReusableCell(withIdentifier: "LevelCell") as! LevelCell
		
		cell.renderLevelCell(fancy: level.fancy, index: indexPath.row, hidden: !hidden)
		
		return cell
	}
	
	
}
