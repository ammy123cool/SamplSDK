//
//  SwyftRequestHandler.swift
//  SwyftSDK
//
//  Created by Amit Dhawan on 06/02/17.
//  Copyright © 2017 Swyft Media. All rights reserved.
//

import UIKit

class SwyftRequestHandler: NSObject {
    static let sharedRequestHandler = SwyftRequestHandler()
    // make Post request
    func sendPostRequest(forRequest urlRequest: URLRequest, withData data: Data?, completionHandler:@escaping (_ repsonse: JSON?, _ error: Error?) -> ())
    {
        var urlRequest: URLRequest = urlRequest
        urlRequest.httpMethod = "POST"
        if data != nil
        {
            urlRequest.httpBody = data
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else{
                completionHandler(nil, error)
                return
            }
            let httpStatus = response as? HTTPURLResponse
            let httpError = apiError.checkErrorCode((httpStatus?.statusCode)!)
            if httpStatus?.statusCode != 200 {
                completionHandler(nil, httpError)
                return
            }
            let responseJSON =  JSON(data: data)
            // create json object from data
            completionHandler(responseJSON, error)
        }
        task.resume()
    }
    
    //make get request
    func sendGetRequest(forRequest urlRequest:URLRequest, withHeaders headers: [String: String],completionHandler:@escaping (_ repsonseString: JSON?, _ error: Error?) -> ()) {
        var urlRequest: URLRequest = urlRequest
        urlRequest.httpMethod = "GET"
        for (key,headerValue) in headers {
            urlRequest.setValue(headerValue, forHTTPHeaderField:key)
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else{
                completionHandler(nil, error)
                return
            }
            let httpStatus = response as? HTTPURLResponse
            let httpError: Error = apiError.checkErrorCode((httpStatus?.statusCode)!)
            
            if httpStatus?.statusCode != 200 {
                completionHandler(nil, httpError)
                return
            }
            let responseJSON =  JSON(data: data)
            completionHandler(responseJSON, error)
        }
        task.resume()
    }
    
}
