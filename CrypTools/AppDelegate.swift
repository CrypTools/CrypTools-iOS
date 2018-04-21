//
//  AppDelegate.swift
//  CrypTools
//
//  Created by Arthur Guiot on 13/04/2018.
//  Copyright © 2018 Arthur Guiot. All rights reserved.
//

import UIKit
import OneSignal


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		// Google Analytics
		GoogleReporter.shared.configure(withTrackerId: "UA-109503398-6")
		
		let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
		
		// Replace 'YOUR_APP_ID' with your OneSignal App ID.
		OneSignal.initWithLaunchOptions(launchOptions,
										appId: "68df36e3-7043-4bb4-a10c-156da7b9d24c",
										handleNotificationAction: nil,
										settings: onesignalInitSettings)
		
		OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
		
		// Recommend moving the below line to prompt for push after informing the user about
		//   how your app will use them.
		OneSignal.promptForPushNotifications(userResponse: { accepted in
			print("User accepted notifications: \(accepted)")
		})
		
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		GoogleReporter.shared.session(start: false)
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		GoogleReporter.shared.session(start: true)
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		GoogleReporter.shared.session(start: false)
	}


}

