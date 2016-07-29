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
import SVProgressHUD


class LoginViewController: UIViewController,GIDSignInUIDelegate, GIDSignInDelegate {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet weak var facebookButton: UIButton!
  @IBOutlet weak var googleButton: UIButton!
  
  let sessionManager = SessionManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    
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
  
  @IBAction func emailSignIn(sender: AnyObject) {
    if emailTextField.text == "projas@nearsoft.com"  && passwordTextField.text == "welcome1"{
      
      SessionManager.emailSignIn(emailTextField.text!)
    }else{
      Alert(title: "Ops!", message: "Invalid email and/or password. Try again.").showOkay()
    }
    
    

  }
  
  
  
  //MARK: - Google SignIn methods
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
    if error == nil {
      let newUser = CCUser(WithGoogleUser: user)
      CCUserViewModel.validateUserInServer(newUser)
      SessionManager.googleSignOut()
    }else{
      print("Error: \(error.localizedDescription)")
      
      if error.code != -5 {
        Alert(title: "Ops!", message: "Something went wrong in server. Please try again later.").showOkay()
      }
      
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

