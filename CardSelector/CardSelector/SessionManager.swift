//
//  SessionManager.swift
//  CardSelector
//
//  Created by projas on 6/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Google
import GoogleSignIn

class SessionManager {
  
  func setupSession() {
    let navigationManager = NavigationManager()
    if UserViewModel.existLoggedUser() {
      navigationManager.goMain()
    }else{
      var configureError: NSError?
      GGLContext.sharedInstance().configureWithError(&configureError)
      assert(configureError == nil,"Error configuring Google services: \(configureError)")
      GIDSignIn.sharedInstance().delegate = UIApplication.sharedApplication().delegate as! AppDelegate
      navigationManager.goLogin()
    }
  }
  
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
    if error == nil {
      let newUser = User(WithGoogleUser: user)
      UserViewModel.saveUserIntoReal(newUser)
      
      let navigationManager = NavigationManager()
      navigationManager.goMain()
    }else{
      print("Error: \(error.localizedDescription)")
    }
  }
  
  func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
    if error == nil {
      let user = UserViewModel.getLoggedUser()
      UserViewModel.deleteUserFromRealm(user)
    }else{
      print("Error: \(error.localizedDescription)")
    }
  }
  
}
