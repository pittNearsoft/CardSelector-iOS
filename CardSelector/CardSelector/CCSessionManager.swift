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

class CCSessionManager {
  
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
    CCSessionManager.signInType = .Google
    googleSetupWithSignInDelegate(delegate: delegate)
    GIDSignIn.sharedInstance().signIn()
  }
  
  static func googleSignOut() {
    GIDSignIn.sharedInstance().signOut()
  }
  
  //MARK: - Facebook methods
  static func facebookSignIn(FromViewController viewController: UIViewController) {
    CCSessionManager.signInType = .Facebook
    
    loginManager.loginBehavior = .native
    loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: viewController) { (result, error) in
      if error != nil {
        print("Error: \(error?.localizedDescription)")
      }else if (result?.isCancelled)! {
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
    facebookRequest?.start { (connection, result, error) in
      if error == nil{
        let actualResult = result as! [String: AnyObject]
        
        guard actualResult["email"] != nil else{
          Alert(title: "Oops!", message: "Card Compadre requires your email to sign in.").showOkay()
          return
        }
        
        let newUser = CCUser(WithFacebookUser: result as! [String : AnyObject])
        getFacebookImageForUser(user: newUser)
        
        
      }else{
        print("Error: \(error?.localizedDescription)")
      }
    }.start()
    
  }
  
  static func getFacebookImageForUser(user: CCUser) {
    let request = FBSDKGraphRequest(graphPath: "/\(user.providerId)/picture?redirect=false&type=large", parameters: nil, httpMethod: "GET")
    
    request?.start { (connection, result, error) in
      if error == nil {
        let dict  =  result as! [String : AnyObject]
        user.imageUrl = dict["data"]!["url"]! as! String
        
        CCUserViewModel.validateUserInServer(user: user)
        facebookSignOut()
      }else{
        print("Error getting facebook picture: \(error?.localizedDescription)")
      }
    }.start()
  }
  
  //MARK: - Email methods
  static func emailSignIn(email: String){
    CCUserViewModel.saveUserIntoUserDefaults(user: CCUser(WithEmail: email))
    NavigationManager.goMain()
  }
  
  //MARK: - Middlewares AppDelegate
  static func application(application: UIApplication, openURL url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
    switch CCSessionManager.signInType {
    case .Google:
      return GIDSignIn.sharedInstance().handle(url,
                                                  sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                  annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    case .Facebook:
      return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                   open: url,
                                                                   sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                                                                   annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    case .Email:
      return false
    }
  }
  
  //Method for iOS 8 and before
  static func application(application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    
    switch CCSessionManager.signInType {
    case .Google:
      return GIDSignIn.sharedInstance().handle(url as URL!,
                                                  sourceApplication: sourceApplication,
                                                  annotation: annotation)
    case .Facebook:
      return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                   open: url,
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
