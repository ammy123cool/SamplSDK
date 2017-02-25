//
//  SwyftSDK.swift
//  SwyftSDK
//
//  Created by Brandon Fitzpatrick on 8/22/16.
//  Copyright © 2016 Swyft Media. All rights reserved.
//

import Foundation

import AdSupport

//# MARK: - Main SDK Class

public class SwyftSDK {
  
  open static let  sharedInstance = SwyftSDK()
  
  public init() {
    print("Swyft SDK Initialized")
    self.authenticate { (success, error) in
      if success == true {
        print("Swyft SDK -> Success Authentication")
      }
    }
  }
  
  // Authenticate
   func authenticate(_ completion: ((_ response: Bool?, _ error: Error?) -> Void)! = nil) {
    
    SwyftAPIManager.sharedAPIManager.authenticate { (response, error) in
      if error == nil {
        completion(true,nil)
        return
      }
      completion(false, error)
    }
  }
  
  
  // MARK: Assets
  
  // get all assets
  open func getAllAssets(completion:@escaping (_ response: [String: Any]?,_ error:Error?) -> ()) {
    SwyftAPIManager.sharedAPIManager.getAllAssets { (response, error) in
      completion(response?.dictionaryObject,error)
    }
  }
  
  // get all trending assets
  open func getTrendingAssets(completion:@escaping (_ response: [String: Any]?,_ error:Error?) -> ()) {
    SwyftAPIManager.sharedAPIManager.getTrendingAssets { (response, error) in
      completion(response?.dictionaryObject,error)
    }
  }
  
  // MARK: Categories
  open func getCategories(completion:@escaping (_ response: [String: Any]?,_ error:Error?) -> ()) {
    SwyftAPIManager.sharedAPIManager.getCategories { (response, error) in
      completion(response?.dictionaryObject,error)
    }
  }
  
  // get Category
  open func getCategory(forCategoryId categoryId: String, completion:@escaping (_ response: [String: Any]?,_ error:Error?) -> ()) {
    SwyftAPIManager.sharedAPIManager.getCategory(forCategoryId: categoryId) { (response, error) in
      completion(response?.dictionaryObject,error)
    }
  }
  
  // get CategoryAssets
  open func getCategoryAssets(forCategoryId categoryId: String,completion:@escaping (_ response: [String: Any]?,_ error:Error?) -> ()) {
    SwyftAPIManager.sharedAPIManager.getCategoryAssets(forCategoryId: categoryId) { (response, error) in
      completion(response?.dictionaryObject,error)
    }
  }
  
  
  
 
  // MARK: Packs
  open func getAllPacks(completion:@escaping (_ response: [String: Any]?,_ error:Error?) -> ()) {
    SwyftAPIManager.sharedAPIManager.getAllPacks { (response, error) in
      completion(response?.dictionaryObject,error)
    }
  }
  
  open func getPack(forPackId packId: String, completion:@escaping (_ response: [String: Any]?,_ error:Error?) -> ()) {
    SwyftAPIManager.sharedAPIManager.getPack(forPackId: packId) { (response, error) in
      completion(response?.dictionaryObject,error)
    }
  }
  
  // Get All Assets for pack id
  open func getAllAssets(forPackId packId: String, completion: @escaping ((_ response: [String: Any]?, _ error: Error?) -> Void))
  {
    SwyftAPIManager.sharedAPIManager.getAllAssets(forPackId: packId) { (response,error) in
      completion(response?["packs"].dictionaryObject,error)
    }
  }
}

