//
//  CCUserViewModel.swift
//  CardSelector
//
//  Created by projas on 7/1/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCUserViewModel {
  private static let defaults = NSUserDefaults.standardUserDefaults()
  private static let objKey = "ccUser"
  private static let userService = CCUserService()
  
  static func saveUserIntoUserDefaults(user: CCUser) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(user)
    defaults.setObject(data, forKey: objKey)
  }
  
  static func deleteUserFromUserDefaults(user: CCUser) {
    defaults.removeObjectForKey(objKey)
  }
  
  static func deleteLoggedUser() {
    let user = CCUserViewModel.getLoggedUser()
    deleteUserFromUserDefaults(user!)
  }
  
  static func getLoggedUser() -> CCUser?{
    
    var user: CCUser? = nil
    if let data = defaults.objectForKey(objKey) as? NSData {
      user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? CCUser
    }
    
    return user
  }
  
  static func existLoggedUser() -> Bool {
    return getLoggedUser() != nil
  }
  
  static func getUserProfileWithEmail(email: String, completion: (profile: CCUser?)-> Void, onError: (error: NSError)->Void ) {
    userService.getUserProfileWithEmail(email, completion: { (jsonProfile) in
      
      if jsonProfile != nil {
        let user: CCUser = Mapper<CCUser>().map(jsonProfile)!
        completion(profile: user)
        return
      }
      
      completion(profile: nil)
      
    }) { (error) in
      onError(error: error)
    }
  }
  
  static func saveUserIntoServer(user: CCUser, completion: (profile: CCUser?)-> Void, onError: (error: NSError)->Void) {
    userService.saveUserIntoServer(user, completion: { (jsonProfile) in
      
      let user: CCUser = Mapper<CCUser>().map(jsonProfile)!
      completion(profile: user)
      
    }) { (error) in
      onError(error: error)
    }
  }
  
  
}
