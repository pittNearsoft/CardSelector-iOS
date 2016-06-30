//
//  SessionManager.swift
//  CardSelector
//
//  Created by projas on 6/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Google
import GoogleSignIn

import FBSDKCoreKit
import FBSDKLoginKit


enum SignInType {
  case Email
  case Facebook
  case Google
}

class SessionManager {
  
  //let navigationManager = NavigationManager()
  private static var signInType: SignInType = .Email
  
  static func setupSession() {
    
    
    if CardUserViewModel.existLoggedUser() {
      NavigationManager.goMain()
    }else{
      var configureError: NSError?
      GGLContext.sharedInstance().configureWithError(&configureError)
      assert(configureError == nil,"Error configuring Google services: \(configureError)")
      GIDSignIn.sharedInstance().delegate = UIApplication.sharedApplication().delegate as! AppDelegate
      NavigationManager.goLogin()
    }
  }
  
  static func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
    if error == nil {
      let newUser = CardUser(WithGoogleUser: user)
      CardUserViewModel.saveUserIntoReal(newUser)
      
      
      NavigationManager.goMain()
    }else{
      print("Error: \(error.localizedDescription)")
    }
  }
  
  static func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
    if error == nil {
      let user = CardUserViewModel.getLoggedUser()
      CardUserViewModel.deleteUserFromRealm(user)
    }else{
      print("Error: \(error.localizedDescription)")
    }
  }
  
  static func googleSignIn() {
    SessionManager.signInType = .Google
    GIDSignIn.sharedInstance().signIn()
  }
  
  static func googleSignOut() {
    GIDSignIn.sharedInstance().signOut()
    let user = CardUserViewModel.getLoggedUser()
    CardUserViewModel.deleteUserFromRealm(user)
    SessionManager.setupSession()
  }
  
  
  static func facebookSignIn(FromViewController viewController: UIViewController) {
    SessionManager.signInType = .Facebook
    
    let loginManager = FBSDKLoginManager()
    loginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: viewController) { (result, error) in
      if error != nil {
        print("Error: \(error.localizedDescription)")
      }else if result.isCancelled {
        print("Operation cancelled")
      }else{
        self.getFacebookData()
        
      }
    }
  }
  
  static func facebookSignOut() {
    let logOutManager = FBSDKLoginManager()
    logOutManager.logOut()
    let user = CardUserViewModel.getLoggedUser()
    CardUserViewModel.deleteUserFromRealm(user)
    SessionManager.setupSession()
  }
  
  static func getFacebookData() {
    let facebookRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, name"])
    facebookRequest.startWithCompletionHandler { (connection, result, error) in
      if error == nil{
        let newUser = CardUser(WithFacebookUser: result as! [String : AnyObject])
        CardUserViewModel.saveUserIntoReal(newUser)
        NavigationManager.goMain()
      }else{
        print("Error: \(error.localizedDescription)")
      }
    }
  }
  
  static func emailSignOut() {
    print("Implement this please!")
  }
  
  static func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
    switch SessionManager.signInType {
    case .Google:
      return GIDSignIn.sharedInstance().handleURL(url,
                                                  sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                  annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    case .Facebook:
      return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                   openURL: url,
                                                                   sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String,
                                                                   annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    case .Email:
      return false
    }
  }
  
  //Method for iOS 8 and before
  static func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    
    switch SessionManager.signInType {
    case .Google:
      return GIDSignIn.sharedInstance().handleURL(url,
                                                  sourceApplication: sourceApplication,
                                                  annotation: annotation)
    case .Facebook:
      return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                   openURL: url,
                                                                   sourceApplication: sourceApplication,
                                                                   annotation: annotation)
    case .Email:
      return false
    }
    
  }
  
  static func logOut() {
    switch SessionManager.signInType {
    case .Google:
      googleSignOut()
    case .Facebook:
      facebookSignOut()
    case .Email:
      emailSignOut()
    }

  }
  
}
