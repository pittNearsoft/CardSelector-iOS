//
//  ViewController.swift
//  CardSelector
//
//  Created by projas on 6/26/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import LKAlertController


class LoginViewController: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate {

  
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet weak var facebookButton: UIButton!
  @IBOutlet weak var googleButton: UIButton!
  
  let sessionManager = SessionManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailButton.layer.cornerRadius = 5
    emailButton.clipsToBounds = true
    
    facebookButton.layer.cornerRadius = 5
    facebookButton.clipsToBounds = true
    
    googleButton.layer.cornerRadius = 5
    googleButton.clipsToBounds = true
    
    
    GIDSignIn.sharedInstance().uiDelegate = self
  }

  @IBAction func googleSignIn(sender: AnyObject) {
    SessionManager.googleSignInWithDelegate(self)
  }
  
  @IBAction func facebookSignIn(sender: AnyObject) {
    SessionManager.facebookSignIn(FromViewController: self)
  }
  
  @IBAction func createAccount(sender: AnyObject) {
    Alert(title: "Ops!", message: "This feature is not available yet!").showOkay()
  }
  
  
  //MARK: - Google SignIn methods
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
    if error == nil {
      let newUser = CCUser(WithGoogleUser: user)
      CCUserViewModel.saveUserIntoReal(newUser)
      
      
      NavigationManager.goMain()
    }else{
      print("Error: \(error.localizedDescription)")
    }
  }
  
  func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
    if error == nil {
      CCUserViewModel.deleteLoggedUser()
      NavigationManager.goLogin()
    }else{
      print("Error: \(error.localizedDescription)")
    }
  }
  
  
}

