//
//  Ipify.swift
//  Ipify
//
//  Created by Amit Dhawan on 1/10/17.
//  Copyright © 2017 Amit Dhawan. All rights reserved.
//

import Foundation

public struct SMIpify {
	
	public typealias JSONDictionary = [String: Any]
	public typealias CompletionHandler = (SM_Result) -> Void
	
	public enum SM_Result {
		case success(String)
		case failure(Error)
	}
	
	enum SM_CustomError: LocalizedError {
		case noData
		case parsingJson
		case unknown
		
		var errorDescription: String? {
			switch self {
			case .noData:
				return "There was no data on the server response."
			case .parsingJson:
				return "Error parsing the JSON file from the server."
			case .unknown:
				return "Unkown error."
			}
		}
	}
	
	
	public static func SM_getPublicIPAddress(completion: @escaping CompletionHandler) {
		let url = URL(string: "https://api.ipify.org?format=json")!
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard error == nil else {
				if let error = error {
					completion(SM_Result.failure(error))
				} else {
					completion(SM_Result.failure(SM_CustomError.unknown))
				}
				return
			}
			
			guard let data = data else {
				completion(SM_Result.failure(SM_CustomError.noData))
				return
			}
			
			do {
				if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary, let ip = json["ip"] as? String {
					completion(SM_Result.success(ip))
				}
			} catch {
				completion(SM_Result.failure(SM_CustomError.parsingJson))
			}
		}.resume()
	}
}
