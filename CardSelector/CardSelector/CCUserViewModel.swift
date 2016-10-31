//
//  CCUserViewModel.swift
//  CardSelector
//
//  Created by projas on 7/1/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper
import SVProgressHUD
import LKAlertController

class CCUserViewModel {
  private static let defaults = UserDefaults.standard
  private static let objKey = "ccUser"
  private static let userService = CCUserService()
  
  static func saveUserIntoUserDefaults(user: CCUser) {
    let data = NSKeyedArchiver.archivedData(withRootObject: user)
    defaults.set(data, forKey: objKey)
  }
  
  static func deleteUserFromUserDefaults(user: CCUser) {
    defaults.removeObject(forKey: objKey)
  }
  
  static func deleteLoggedUser() {
    let user = CCUserViewModel.getLoggedUser()
    deleteUserFromUserDefaults(user: user!)
  }
  
  static func getLoggedUser() -> CCUser?{
    
    var user: CCUser? = nil
    if let data = defaults.object(forKey: objKey) as? NSData {
      user = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? CCUser
    }
    
    return user
  }
  
  static func existLoggedUser() -> Bool {
    return getLoggedUser() != nil
  }
  
  static func getUserProfileWithEmail(email: String, completion: @escaping (_ profile: CCUser?)-> Void, onError: @escaping (_ error: NSError)->Void ) {
    userService.getUserProfileWithEmail(email: email, completion: { (jsonProfile) in
      
      if jsonProfile != nil {
        let user: CCUser = Mapper().map(JSON: jsonProfile!)!
        completion(user)
        return
      }
      
      completion(nil)
      
    }) { (error) in
      onError(error)
    }
  }
  
  static func saveUserIntoServer(user: CCUser, password: String = "" , completion: @escaping (_ profile: CCUser?)-> Void, onError: @escaping (_ error: NSError)->Void) {
    userService.saveUserIntoServer(user: user, password: password, completion: { (jsonProfile) in
      
      let user: CCUser = Mapper().map(JSON: jsonProfile)!//.map(jsonProfile)!
      completion(user)
      
    }) { (error) in
      onError(error)
    }
  }
  
  private static func validateUserInServer(newUser: CCUser, completion: @escaping (_ profile: CCUser)-> Void, onError: @escaping (_ error: NSError)->Void){
    
    CCUserViewModel.getUserProfileWithEmail(email: newUser.email, completion: { (profile) in
      
      if profile == nil {
        CCUserViewModel.saveUserIntoServer(user: newUser, completion: { (profile) in
          completion(profile!)
        }, onError: { (error) in
          onError(error)
        })
      }else{
        completion(profile!)
      }
      
      
    }, onError: { (error) in
      onError(error)
    })
  }
  
  
  static func validateUserInServer(user: CCUser) {
    SVProgressHUD.show()
    CCUserViewModel.validateUserInServer(newUser: user, completion: { (profile) in
      SVProgressHUD.dismiss()
      
      //Replace google Id with user Id from server
      user.userId = profile.userId
      
      //Retrieve saved cards
      user.profileCards = profile.profileCards
      
      //Now save new user in cache
      CCUserViewModel.saveUserIntoUserDefaults(user: user)
      NavigationManager.goMain()
      
      }, onError: { (error) in
        SVProgressHUD.dismiss()
        print(error.localizedDescription)
        Alert(title: "Oops!", message: "Something went wrong in server. Please try again later.").showOkay()
    })
  }
  
  static func authenticateUserWithEmail(email: String, password: String, completion: @escaping (_ user: CCUser?)-> Void, onError: @escaping (_ error: NSError)->Void){
    userService.authenticateUserWithEmail(email: email, password: password, completion: { (jsonProfile) in
      
      if jsonProfile != nil{
        let user: CCUser = Mapper().map(JSON: jsonProfile!)!//.map(jsonProfile)!
        completion(user)
      }else{
        completion(nil)
      }
      
      
    }) { (error) in
        onError(error)
    }
  }
  
  
}
