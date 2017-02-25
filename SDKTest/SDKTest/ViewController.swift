//
//  ViewController.swift
//  SDKTest
//
//  Created by Brandon Fitzpatrick on 8/19/16.
//  Copyright © 2016 Swyft Media. All rights reserved.
//

import UIKit
import SwyftSDK

class ViewController: UIViewController, SwyftConfigDelegate, SwyftResponseDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let swyftSDK = SwyftSDK()
        swyftSDK.configDelegate = self;
        swyftSDK.responseDelegate = self;
        
        //swyftSDK.doSomething()
        
        /*
        swyftSDK.getAllAssets([
            //"fields": "",
            "limit":  12,
            "offset": 0
        ])
        swyftSDK.getTrendingAssets([
            //"fields": "",
            "limit":  12,
            "offset": 0
        ])
        
        swyftSDK.getCategories([
            //"fields": "",
            "limit":  12,
            "offset": 0
        ])
        
        swyftSDK.getCategory([
            //"fields": "",
            "categoryId": 987654321
        ])
        
        swyftSDK.getPacks([
            //"fields": "",
            "limit":  12,
            "offset": 0
        ])
        
        swyftSDK.getPack([
            //"fields": "",
            "packId": 987654321
        ])
         */
        
        swyftSDK.getPackAssets([
            //"fields": "",
            "packId": 987654321
         ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //# MARK: - SDK protocol methods
    
    func configSwyftSDK() -> Dictionary <String,String> {
        // Test values here are for BBM
        let swyftSDKConfig: [String:String] = [
            "client_id":        "a18f67a32d9f",
            "client_secret":    "bc7a37d6-902d-453f-9ebe-249c9df2403f",
            "grant_type":       "password",
            "u_id":             "12345"
        ]
        return swyftSDKConfig
    }
    
    func didReceiveSwyftSDKResponse(requestName: String, response: JSON) {
        print(requestName + " returned response of:")
        print(response)
    }

}

