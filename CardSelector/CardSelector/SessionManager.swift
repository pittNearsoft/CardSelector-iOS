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

import LKAlertController

enum SignInType: Int {
  case Email
  case Facebook
  case Google
}

class SessionManager {
  
  //let navigationManager = NavigationManager()
  private static var signInType: SignInType = .Email
  
  private static let loginManager = FBSDKLoginManager()
  
  private static func googleSetupWithSignInDelegate(delegate: GIDSignInDelegate){
    var configureError: NSError?
    GGLContext.sharedInstance().configureWithError(&configureError)
    assert(configureError == nil,"Error configuring Google services: \(configureError)")
    GIDSignIn.sharedInstance().delegate = delegate//UIApplication.sharedApplication().delegate as! AppDelegate
  }
  
  static func googleSignInWithDelegate(delegate: GIDSignInDelegate) {
    SessionManager.signInType = .Google
    googleSetupWithSignInDelegate(delegate)
    GIDSignIn.sharedInstance().signIn()
  }
  
  static func googleSignOut() {
    GIDSignIn.sharedInstance().signOut()
  }
  
  //MARK: - Facebook methods
  static func facebookSignIn(FromViewController viewController: UIViewController) {
    SessionManager.signInType = .Facebook
    
    loginManager.loginBehavior = .Native
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
    loginManager.logOut()
  }
  
  static func getFacebookData() {
    let facebookRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, first_name, last_name, gender, birthday"])
    facebookRequest.startWithCompletionHandler { (connection, result, error) in
      if error == nil{
        
        guard (result["email"]!) != nil else{
          Alert(title: "Oops!", message: "Card Compadre requires your email to sign in.").showOkay()
          return
        }
        
        let newUser = CCUser(WithFacebookUser: result as! [String : AnyObject])
        getFacebookImageForUser(newUser)
        
        
      }else{
        print("Error: \(error.localizedDescription)")
      }
    }
    
  }
  
  static func getFacebookImageForUser(user: CCUser) {
    let request = FBSDKGraphRequest(graphPath: "/\(user.providerId)/picture?redirect=false&type=large", parameters: nil, HTTPMethod: "GET")
    
    request.startWithCompletionHandler { (connection, result, error) in
      if error == nil {
        let dict  =  result as! [String : AnyObject]
        user.imageUrl = dict["data"]!["url"]! as! String
        
        CCUserViewModel.validateUserInServer(user)
        facebookSignOut()
      }else{
        print("Error getting facebook picture: \(error.localizedDescription)")
      }
    }
  }
  
  //MARK: - Email methods
  static func emailSignIn(email: String){
    CCUserViewModel.saveUserIntoUserDefaults(CCUser(WithEmail: email))
    NavigationManager.goMain()
  }
  
  //MARK: - Middlewares AppDelegate
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
    CCUserViewModel.deleteLoggedUser()
    NavigationManager.goLogin()
  }
  
}
