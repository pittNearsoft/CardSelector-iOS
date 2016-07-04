//
//  CCUserViewModel.swift
//  CardSelector
//
//  Created by projas on 7/1/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation

class CCUserViewModel {
  private static let defaults = NSUserDefaults.standardUserDefaults()
  private static let objKey = "ccUser"
  
  static func saveUserIntoReal(user: CCUser) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(user)
    defaults.setObject(data, forKey: objKey)
  }
  
  static func deleteUserFromRealm(user: CCUser) {
    defaults.removeObjectForKey(objKey)
  }
  
  static func deleteLoggedUser() {
    let user = CCUserViewModel.getLoggedUser()
    deleteUserFromRealm(user!)
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
}
