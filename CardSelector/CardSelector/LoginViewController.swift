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

class LoginViewController: UIViewController,GIDSignInUIDelegate {

  
  @IBOutlet weak var emailButton: UIButton!
  @IBOutlet weak var facebookButton: UIButton!
  @IBOutlet weak var googleButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let loginButton = FBSDKLoginButton()
//    loginButton.center = view.center
//    view.addSubview(loginButton)
    
    emailButton.layer.cornerRadius = 5
    emailButton.clipsToBounds = true
    
    facebookButton.layer.cornerRadius = 5
    facebookButton.clipsToBounds = true
    
    googleButton.layer.cornerRadius = 5
    googleButton.clipsToBounds = true
    
    
    GIDSignIn.sharedInstance().uiDelegate = self
  }

  @IBAction func googleSignIn(sender: AnyObject) {
    GIDSignIn.sharedInstance().signIn()
  }
  
  @IBAction func facebookSignIn(sender: AnyObject) {
    
  }
  
  @IBAction func emailSignIn(sender: AnyObject) {
    
  }
  
}

