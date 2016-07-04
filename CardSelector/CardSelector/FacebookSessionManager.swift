//
//  FacebookSessionManager.swift
//  CardSelector
//
//  Created by projas on 7/3/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

class FacebookSessionManager: SessionTestManager {
  
  static let loginManager = FBSDKLoginManager()
  
  static func signIn() {
    
    loginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"]) { (result, error) in
      if error != nil {
        print("Error: \(error.localizedDescription)")
      }else if result.isCancelled {
        print("Operation cancelled")
      }else{
        getFacebookData()
        
      }
    }
  }
  
  static func signOut() {
    loginManager.logOut()
    CCUserViewModel.deleteLoggedUser()
    NavigationManager.goLogin()
  }
  
  
  private static func getFacebookData() {
    let facebookRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, name"])
    facebookRequest.startWithCompletionHandler { (connection, result, error) in
      if error == nil{
        let newUser = CCUser(WithFacebookUser: result as! [String : AnyObject])
        CCUserViewModel.saveUserIntoReal(newUser)
        NavigationManager.goMain()
      }else{
        print("Error: \(error.localizedDescription)")
      }
    }
  }
}
