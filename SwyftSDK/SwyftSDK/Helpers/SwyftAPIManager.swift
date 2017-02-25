//
//  SwyftAPIManager.swift
//  SwyftSDK
//
//  Created by Amit Dhawan on 06/02/17.
//  Copyright © 2017 Swyft Media. All rights reserved.
//

import UIKit
import AdSupport


fileprivate let kClientSecret = "client_secret"
fileprivate let kClientId = "client_id"
fileprivate let kGrantType = "grant_type"
fileprivate let kClientIdValue = "clientid"
fileprivate let kClientSecretValue = "clientsecret"
fileprivate let kGrantTypeValue = "granttype"
fileprivate let kUId = "u_id"
fileprivate let kDeviceIp = "device_ip"
fileprivate let kAccessToken = "access_token"
fileprivate let kADId = "ad_id"
fileprivate let kFields = "fields"
fileprivate let kAll = "all"
fileprivate let kGroup = "group"
fileprivate let kId = "id"
fileprivate let kName = "name"
fileprivate let kPrice = "price"
fileprivate let kType = "type"
fileprivate let kAsset = "asset"
fileprivate let kHeroAsset = "hero_asset"
fileprivate let kCount = "count"
fileprivate let kLimit = "asset_limit"
fileprivate let kOffset = "asset_offset"
fileprivate let kDisplayOrder = "display_order"
fileprivate let kAlt_Sizes = "alt_sizes"
fileprivate let kURL = "url"
fileprivate let kAuthorization = "Authorization"
fileprivate let kAssets = "assets"
fileprivate let kMetaData = "metadata"
fileprivate let kAccess_Token = "access_token"
fileprivate let kOAuth = "oauth"
fileprivate let kExpiresIn = "expires_in"

let kSwyftBaseURL = "http://ec2-52-71-111-120.compute-1.amazonaws.com"

let kAuthPath           = "/oauth/token/"
let kPacksPath          = "/packs/"
let kAssetsPath         = "/assets/"
let kTrendingAssetsPath = "/assets/trending/"
let kCategoriesPath     = "/categories/"

class SwyftAPIManager: NSObject {
    
    static let sharedAPIManager = SwyftAPIManager()
    
    fileprivate var idfa = ""
    
    fileprivate var uuid = ""
    
    fileprivate var token =  ""
    // Invalid Token to test
    // "eyJhbGciOiJIUzI1NiJ9.Nzg0MTczZDFhMjRlYTMyMTU0MzI0NTcxNQ.6rbKmUeYgUuE9-UDt_3uIBZzHB60mT5fK66HNzFh9vU"
    
    fileprivate var isAuthenticated = false
    
    
    
    // Authenticate the token
    func authenticate(completion:@escaping (_ success: Bool?,_ error:Error?) -> ()) {
        let paramDictionary = dataFromInfoPlist()
        // assertions
        assert((paramDictionary[kClientSecretValue] as? String)?.isEmpty == false,"clientSecret is empty")
        assert((paramDictionary[kClientIdValue] as? String)?.isEmpty == false,"clientId is empty")
        assert((paramDictionary[kGrantTypeValue] as? String)?.isEmpty == false,"grantType is empty")
        
        let urlString = String(format:"\(kSwyftBaseURL)\(kAuthPath)?&\(kClientId)=\(paramDictionary[kClientIdValue] as! String)&\(kClientSecret)=\(paramDictionary[kClientSecretValue] as! String)&\(kGrantType)=\(paramDictionary[kGrantTypeValue] as! String)")
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        // make post request
        
        SwyftRequestHandler.sharedRequestHandler.sendPostRequest(forRequest: urlRequest, withData: nil) { (response, error) in
            if error == nil {
                self.isAuthenticated = true
                self.token = (response?[kOAuth][kAccess_Token].stringValue)!
                let expiry = (response?[kOAuth][kExpiresIn].doubleValue)!
                // Invalid token
                // "eyJhbGciOiJIUzI1NiJ9.Nzg0MTczZDFhMjRlYTMyMTU0MzI0NTcxNQ.6rbKmUeYgUuE9-UDt_3uIBZzHB60mT5fK66HNzFh9vU"
                // Set state to be unauthenticated after token expires
                self.setTimeout(delay: expiry){() in
                    self.isAuthenticated = false
                    self.token = ""
                }
                completion(true,nil)
            }else{
                completion(false,error)
            }
        }
        
    }
    
    // MARK: Assets
    
    // get all assets
    func getAllAssets(completion:@escaping (_ response: JSON?,_ error:Error?) -> ()) {
        let urlString = String(format:"\(kSwyftBaseURL)\(kAssetsPath)?\(kUId)=\(self.getUUID())&\(kFields)=\(kAll)&\(kDeviceIp)&\(kADId)=\(self.getIDFA())")
        makeAndSendRequest(urlString: urlString, headers: [kAuthorization: self.token]) { (response, error) in
            completion(response, error)
        }
    }
    
    // get trending assets
    func getTrendingAssets(completion:@escaping (_ response: JSON?,_ error:Error?) -> ()) {
        let urlString = String(format:"\(kSwyftBaseURL)\(kTrendingAssetsPath)?\(kUId)=\(self.getUUID())&\(kFields)=\(kAll)&\(kDeviceIp)&\(kADId)=\(self.getIDFA())")
        makeAndSendRequest(urlString: urlString, headers: [kAuthorization: self.token]) { (response, error) in
            completion(response, error)
        }
    }
    
    // get all assets by packId
    func getAllAssets(forPackId packId: String, completion:@escaping (_ response: JSON?,_ error:Error?) -> ()) {
        assert(packId.isEmpty == false, "packId is empty")
        let urlString = String(format:"\(kSwyftBaseURL)\(kPacksPath)\(packId)/\(kAssets)?\(kUId)=\(self.getUUID())&\(kDeviceIp)&\(kFields)=\(kAll)&\(kLimit)=500&\(kOffset)=0&\(kADId)=\(self.getIDFA())")
        makeAndSendRequest(urlString: urlString, headers: [kAuthorization: self.token]) { (response, error) in
            completion(response, error)
        }
    }
    
    
    // MARK: Categories
    
    // get Categories
    func getCategories(completion:@escaping (_ response: JSON?,_ error:Error?) -> ()) {
        let urlString = String(format:"\(kSwyftBaseURL)\(kCategoriesPath)?\(kUId)=\(self.getUUID())&\(kFields)=\(kAll)&\(kDeviceIp)&\(kADId)=\(self.getIDFA())")
        makeAndSendRequest(urlString: urlString, headers: [kAuthorization: self.token]) { (response, error) in
            completion(response, error)
        }
    }
    
    // get Category
    func getCategory(forCategoryId categoryId: String, completion:@escaping (_ response: JSON?,_ error:Error?) -> ()) {
        assert(categoryId.isEmpty == false, "Invalid parameter")
        let urlString = String(format:"\(kSwyftBaseURL)\(kCategoriesPath)\(categoryId)?\(kUId)=\(self.getUUID())&\(kFields)=\(kAll)&\(kDeviceIp)&\(kADId)=\(self.getIDFA())")
        makeAndSendRequest(urlString: urlString, headers: [kAuthorization: self.token]) { (response, error) in
            completion(response, error)
        }
    }
    
    
    // get CategoryAssets
    func getCategoryAssets(forCategoryId categoryId: String,completion:@escaping (_ response: JSON?,_ error:Error?) -> ()) {
        assert(categoryId.isEmpty == false, "Invalid parameter")
        let urlString = String(format:"\(kSwyftBaseURL)\(kCategoriesPath)\(categoryId)/\(kAssets)?\(kUId)=\(self.getUUID())&\(kFields)=\(kAll)&\(kDeviceIp)&\(kADId)=\(self.getIDFA())")
        makeAndSendRequest(urlString: urlString, headers: [kAuthorization: self.token]) { (response, error) in
            completion(response, error)
        }
    }
    
    // MARK: Packs
    
    //get all packs
    func getAllPacks(completion:@escaping (_ response: JSON?,_ error:Error?) -> ()) {
        let urlString = String(format:"\(kSwyftBaseURL)\(kPacksPath)?\(kUId)=\(self.getUUID())&\(kDeviceIp)&\(kADId)=\(self.getIDFA())")
        makeAndSendRequest(urlString: urlString, headers: [kAuthorization: self.token]) { (response, error) in
            completion(response, error)
        }
    }
    
    
    // get Pack by packId
    func getPack(forPackId packId: String, completion:@escaping (_ response: JSON?,_ error:Error?) -> ()) {
        assert(packId.isEmpty == false, "Invalid parameter")
        let urlString = String(format:"\(kSwyftBaseURL)\(kPacksPath)\(packId)?\(kUId)=\(self.getUUID())&\(kFields)=\(kAll)&\(kDeviceIp)&\(kADId)=\(self.getIDFA())")
        makeAndSendRequest(urlString: urlString, headers: [kAuthorization: self.token]) { (response, error) in
            completion(response, error)
        }
    }
    
    // make and hit the URL request
    fileprivate func makeAndSendRequest(urlString: String, headers: [String: Any], completion:@escaping (_ response: JSON?,_ error:Error?) -> ()) {
        SMIpify.SM_getPublicIPAddress { (result) in
            switch result {
            case .success(let ip):
                var newUrlString = urlString.replacingOccurrences(of: kDeviceIp, with: String(format: "\(kDeviceIp)=\(ip)"))
                // allow special characters in URL
                newUrlString = newUrlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
                let url = URL(string: newUrlString)
                let urlRequest = URLRequest(url: url!)
                SwyftRequestHandler.sharedRequestHandler.sendGetRequest(forRequest: urlRequest, withHeaders: [kAuthorization: self.token], completionHandler: { (response, error) in
                    if error == nil { //Success case
                        completion(response,nil)
                    }else if error as? apiError == apiError.InvalidToken || self.isAuthenticated == false { // Fetch token again
                        self.authenticate(completion: { (success, error) in
                            if success ==  true {
                                // For success make the last request call after fresh token received
                                self.makeAndSendRequest(urlString: urlString, headers: [kAuthorization: self.token], completion: { (response, error) in
                                    completion(response,error)
                                })
                            }else {
                                completion(nil,error)
                            }
                        })
                    } else {
                        // Fallback neither Success nor Token Expired
                        completion(nil,error)
                    }
                });
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil,error)
                
            }
        }
    }
    
    
    // MARK: Private methods
    fileprivate func dataFromInfoPlist() -> [String: Any] {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        return myDict as! [String : Any];
    }
    
    // get device AdID
    fileprivate func getIDFA() -> String {
        // check if user gave permission for access Adid
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            idfa = (ASIdentifierManager.shared().advertisingIdentifier?.uuidString)!
        }
        return idfa
    }
    
    // get device UDID
    fileprivate func getUUID() -> String {
        if uuid.isEmpty == true {
            uuid = UUID().uuidString
        }
        return uuid
    }
    
    // Timer helper function
    private func setTimeout(delay:TimeInterval, block:@escaping ()->Void)  {
        Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
    
}
