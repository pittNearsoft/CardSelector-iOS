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
    facebookButton.titleLabel?.adjustsFontSizeToFitWidth = true
    facebookButton.contentHorizontalAlignment = .Center
    
    googleButton.layer.cornerRadius = 5
    googleButton.clipsToBounds = true
    googleButton.titleLabel?.adjustsFontSizeToFitWidth = true
    googleButton.contentHorizontalAlignment = .Center
    googleButton.layer.borderWidth = 0.5
    googleButton.layer.borderColor = UIColor ( red: 0.8838, green: 0.8795, blue: 0.8881, alpha: 1.0 ).CGColor
    
    GIDSignIn.sharedInstance().uiDelegate = self
  }

  @IBAction func googleSignIn(sender: AnyObject) {
    SessionManager.googleSignInWithDelegate(self)
  }
  
  @IBAction func facebookSignIn(sender: AnyObject) {
    SessionManager.facebookSignIn(FromViewController: self)
  }
  
  @IBAction func emailSignIn(sender: AnyObject) {
    
    SVProgressHUD.show()
    CCUserViewModel.authenticateUserWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user) in
      
      SVProgressHUD.dismiss()
      guard user != nil else{
        Alert(title: "Oops!", message: "Invalid email and/or password. Try again.").showOkay()
        return
      }
      
      CCUserViewModel.validateUserInServer(user!)
      
    }) { (error) in
      SVProgressHUD.dismiss()
      print(error.localizedDescription)
      Alert(title: "Oops!", message: "Invalid email and/or password. Try again.").showOkay()
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
        Alert(title: "Oops!", message: "Something went wrong in server. Please try again later.").showOkay()
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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "createNewUserSegue" {
      let nav = segue.destinationViewController as! UINavigationController
      let newUserVC = nav.viewControllers[0] as! NewUserViewController
      newUserVC.delegate = self
    }
  }
  

}

extension LoginViewController: NewUserViewControllerDelegate{
  func didSaveNewUserWithEmail(email: String) {
    emailTextField.text = email
  }
}

