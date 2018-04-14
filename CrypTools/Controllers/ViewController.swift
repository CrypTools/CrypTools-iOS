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

class ViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var TableView: UITableView!
	@IBOutlet weak var Loading: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.levels = [] // Emptying levels to make sure that the app is reloading each levels
		
		UIApplication.shared.statusBarStyle = .lightContent
		
		defaults()
		
		TableView.delegate = self
		TableView.dataSource = self
		TableView.rowHeight = 300
		TableView.tableFooterView = UIView(frame: CGRect.zero)
		TableView.separatorStyle = .none
		
		getLevels()
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
	}
	var levels: [Level] = []
	func getLevels() {
		let location = "https://cryptools.github.io/learn/api/challenges.json"
		Alamofire.request(location).responseJSON {
			response in
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
				
				let appGroupID = "group.com.arguiot.CrypTools"
				let defaults = UserDefaults(suiteName: appGroupID)
				defaults?.setValue(self.levels.count, forKey: "levels")
			} catch {
				print("JSON Parsing Error")
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let path = TableView.indexPathForSelectedRow {
			let row = path.row
			let LevelC = segue.destination as! LevelController
			LevelC.level = self.levels[row]
		}
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return levels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let level = levels[indexPath.row]
		
		let cell = TableView.dequeueReusableCell(withIdentifier: "LevelCell") as! LevelCell
		
		cell.renderLevelCell(fancy: level.fancy, index: indexPath.row)
		
		return cell
	}
	
	
}
