//
//  GoogleReporter.swift
//  GoogleReporter
//
//  Created by Kristian Andersen on 22/05/2017.
//  Copyright © 2017 Kristian Co. All rights reserved.
//
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
import Foundation
import WebKit
#endif

extension Dictionary {
	func combinedWith(_ other: [Key: Value]) -> [Key: Value] {
		var dict = self
		for (key, value) in other {
			dict[key] = value
		}
		return dict
	}
}

/// GoogleReporter is a class that enables tracking events to Google Analytics. The class uses the
/// Google Analytics Measurement protocol which is
/// [documented in full here](https://developers.google.com/analytics/devguides/collection/protocol/v1/reference).
///
/// The class support two specific types of events and generic events.
/// - Screen views are reported using `screenView(_:parameters:)` with the name of the screen.
/// - Exceptions are reported using `exception(_:isFatal:parameters:)`.
/// - Generic events are reported using `event(_:action:label:parameters:)`.
///
/// For a full list of all the supported parameters please refer to the [Google Analytics parameter
/// reference](https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters)
///
/// - Note: A valid Google Analytics tracker ID must be set with `configure(withTrackerId:)` before
/// reporting any events.
public class GoogleReporter {
	/// Returns the singleton reporter instance.
	public static let shared = GoogleReporter()
	
	/// Determines if stdout log from network requests are supressed.
	/// Default is true.
	public var quietMode = true
	
	/// 	Specifies if app should use IDFV (`UIDevice.current.identifierForVendor`), instead of generating its own UUID.
	/// 	Default is false
	public var usesVendorIdentifier = false
	
	private static let baseURL = URL(string: "https://www.google-analytics.com/")!
	private static let identifierKey = "co.kristian.GoogleReporter.uniqueUserIdentifier"
	
	private var trackerId: String?
	
	private init() {}
	
	/// Configures the reporter with a Google Analytics Identifier (Tracker ID).
	/// The token can be obtained from the admin page of the tracked Google Analytics entity.
	///
	/// - Parameter trackerId: A valid Google Analytics tracker ID of form UA-XXXXX-XX.
	public func configure(withTrackerId trackerId: String) {
		self.trackerId = trackerId
	}
	
	/// Tracks a screen view event to Google Analytics by setting the `cd`
	/// parameter of the request.
	///
	/// - Parameter name: The name of the screen.
	/// - Parameter parameters: A dictionary of additional parameters for the event.
	public func screenView(_ name: String, parameters: [String: String] = [:]) {
		let data = parameters.combinedWith(["cd": name])
		send(type: "screenView", parameters: data)
	}
	
	/// Tracks a session start to Google Analytics by setting the `sc`
	/// parameter of the request. The `dp` parameter is set to the name
	/// of the application.
	///
	/// - Parameter start: true indicate session started, false - session finished.
	public func session(start: Bool, parameters: [String: String] = [:]) {
		let data = parameters.combinedWith([
			"sc": start ? "start" : "end",
			"dp": appName,
			])
		
		send(type: nil, parameters: data)
	}
	
	/// Tracks an event to Google Analytics.
	///
	/// - Parameter category: The category of the event (ec).
	/// - Parameter action: The action of the event (ea).
	/// - Parameter label: The label of the event (el).
	/// - Parameter parameters: A dictionary of additional parameters for the event.
	public func event(_ category: String, action: String, label: String = "",
					  parameters: [String: String] = [:]) {
		let data = parameters.combinedWith([
			"ec": category,
			"ea": action,
			"el": label,
			])
		
		send(type: "event", parameters: data)
	}
	
	/// Tracks an exception event to Google Analytics.
	///
	/// - Parameter description: The description of the exception (ec).
	/// - Parameter isFatal: Indicates if the exception was fatal to the execution of the program (exf).
	/// - Parameter parameters: A dictionary of additional parameters for the event.
	public func exception(_ description: String, isFatal: Bool,
						  parameters: [String: String] = [:]) {
		let data = parameters.combinedWith([
			"exd": description,
			"exf": String(isFatal),
			])
		
		send(type: "exception", parameters: data)
	}
	
	private func send(type: String?, parameters: [String: String]) {
		guard let trackerId = trackerId else {
			print("GoogleReporter event ignored.")
			print("You must set your tracker ID UA-XXXXX-XX with GoogleReporter.configure()")
			return
		}
		
		var queryArguments: [String: String] = [
			"tid": trackerId,
			"aid": appIdentifier,
			"cid": uniqueUserIdentifier,
			"an": appName,
			"av": formattedVersion,
			"ua": userAgent,
			"ul": userLanguage,
			"sr": screenResolution,
			"v": "1",
			]
		
		if let type = type, !type.isEmpty {
			queryArguments.updateValue(type, forKey: "t")
		}
		
		let arguments = queryArguments.combinedWith(parameters)
		guard let url = GoogleReporter.generateUrl(with: arguments) else {
			return
		}
		
		if !quietMode {
			print("Sending GA Report: ", url.absoluteString)
		}
		
		let session = URLSession.shared
		let task = session.dataTask(with: url) { _, _, error in
			if let errorResponse = error?.localizedDescription {
				print("Failed to deliver GA Request. ", errorResponse)
			}
		}
		
		task.resume()
	}
	
	private static func generateUrl(with parameters: [String: String]) -> URL? {
		let characterSet = CharacterSet.urlPathAllowed
		
		let joined = parameters.reduce("collect?") { path, query in
			let value = query.value.addingPercentEncoding(withAllowedCharacters: characterSet)
			return String(format: "%@%@=%@&", path, query.key, value ?? "")
		}
		
		// Trim the trailing &
		let path = String(joined[..<joined.index(before: joined.endIndex)])
		
		// Make sure we generated a valid URL
		guard let url = URL(string: path, relativeTo: baseURL) else {
			print("GoogleReporter failed to generate a valid GA url for path ",
				  path, " relative to ", baseURL.absoluteString)
			return nil
		}
		
		return url
	}
	
	private lazy var uniqueUserIdentifier: String = {
		#if os(iOS) || os(tvOS) || os(watchOS)
		if let identifier = UIDevice.current.identifierForVendor?.uuidString, self.usesVendorIdentifier {
			return identifier
		}
		#endif
		
		let defaults = UserDefaults.standard
		guard let identifier = defaults.string(forKey: GoogleReporter.identifierKey) else {
			let identifier = UUID().uuidString
			defaults.set(identifier, forKey: GoogleReporter.identifierKey)
			defaults.synchronize()
			
			if !self.quietMode {
				print("New GA user with identifier: ", identifier)
			}
			
			return identifier
		}
		
		return identifier
	}()
	
	public lazy var userAgent: String = {
		#if os(iOS) || os(watchOS) || os(tvOS)
		let currentDevice = UIDevice.current
		let osVersion = currentDevice.systemVersion.replacingOccurrences(of: ".", with: "_")
		let fallbackAgent = "Mozilla/5.0 (\(currentDevice.model); CPU iPhone OS \(osVersion) like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13T534YI" // swiftlint:disable:this line_length
		#if os(tvOS)
		return fallbackAgent
		#else
		let webView = UIWebView()
		return webView.stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? fallbackAgent
		#endif
		#elseif os(OSX)
		let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
		let versionString = osVersion.replacingOccurrences(of: ".", with: "_")
		let fallbackAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X \(versionString)) AppleWebKit/603.2.4 (KHTML, like Gecko) \(self.appName)/\(self.appVersion)" // swiftlint:disable:this line_length
		let webView = WebView()
		return webView.stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? fallbackAgent
		#endif
	}()
	
	private lazy var appName: String = {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "(not set)"
	}()
	
	private lazy var appIdentifier: String = {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? "(not set)"
	}()
	
	private lazy var appVersion: String = {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "(not set)"
	}()
	
	private lazy var appBuild: String = {
		Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "(not set)"
	}()
	
	private lazy var formattedVersion: String = {
		"\(self.appVersion) (\(self.appBuild))"
	}()
	
	private lazy var userLanguage: String = {
		guard let locale = Locale.preferredLanguages.first, locale.count > 0 else {
			return "(not set)"
		}
		
		return locale
	}()
	
	private lazy var screenResolution: String = {
		#if os(iOS) || os(tvOS) || os(watchOS)
		let size = UIScreen.main.nativeBounds.size
		#elseif os(OSX)
		let size = NSScreen.main?.frame.size ?? .zero
		#endif
		
		return "\(size.width)x\(size.height)"
	}()
}
