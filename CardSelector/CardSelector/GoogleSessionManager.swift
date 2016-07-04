//
//  GoogleSessionManager.swift
//  CardSelector
//
//  Created by projas on 7/3/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Google
import GoogleSignIn

class GoogleSessionManager: SessionTestManager {
  private static func googleSetup(){
    var configureError: NSError?
    GGLContext.sharedInstance().configureWithError(&configureError)
    assert(configureError == nil,"Error configuring Google services: \(configureError)")
    GIDSignIn.sharedInstance().delegate = UIApplication.sharedApplication().delegate as! AppDelegate
  }
  
  static func signIn() {
    googleSetup()
    GIDSignIn.sharedInstance().signIn()
  }
  
  static func signOut() {
    GIDSignIn.sharedInstance().signOut()
    CCUserViewModel.deleteLoggedUser()
    NavigationManager.goLogin()
  }
  
  //MARK: - Google methods
  static func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
    if error == nil {
      let newUser = CCUser(WithGoogleUser: user)
      CCUserViewModel.saveUserIntoReal(newUser)
      NavigationManager.goMain()
    }else{
      print("Error: \(error.localizedDescription)")
    }
  }
  
  static func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
    if error == nil {
      CCUserViewModel.deleteLoggedUser()
      NavigationManager.goLogin()
    }else{
      print("Error: \(error.localizedDescription)")
    }
  }
}
