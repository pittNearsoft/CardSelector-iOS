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
  
  let sessionManager = CCSessionManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    
    emailButton.layer.cornerRadius = 5
    emailButton.clipsToBounds = true
    
    facebookButton.layer.cornerRadius = 5
    facebookButton.clipsToBounds = true
    facebookButton.titleLabel?.adjustsFontSizeToFitWidth = true
    facebookButton.contentHorizontalAlignment = .center
    
    googleButton.layer.cornerRadius = 5
    googleButton.clipsToBounds = true
    googleButton.titleLabel?.adjustsFontSizeToFitWidth = true
    googleButton.contentHorizontalAlignment = .center
    googleButton.layer.borderWidth = 0.5
    googleButton.layer.borderColor = UIColor ( red: 0.8838, green: 0.8795, blue: 0.8881, alpha: 1.0 ).cgColor
    
    GIDSignIn.sharedInstance().uiDelegate = self
  }

  @IBAction func googleSignIn(sender: AnyObject) {
    CCSessionManager.googleSignInWithDelegate(delegate: self)
  }
  
  @IBAction func facebookSignIn(sender: AnyObject) {
    CCSessionManager.facebookSignIn(FromViewController: self)
  }
  
  @IBAction func emailSignIn(sender: AnyObject) {
    
    if emailTextField.text!.isEmpty {
      Alert(title: "Oops!", message: "Email field is empty").showOkay()
      return
    }
    
    
    if passwordTextField.text!.isEmpty {
      Alert(title: "Oops!", message: "Password field is empty").showOkay()
      return
    }
    
    
    SVProgressHUD.show()
    CCUserViewModel.authenticateUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!, completion: { (user) in
      
      
      guard user != nil else{
        SVProgressHUD.dismiss()
        Alert(title: "Oops!", message: "Invalid email and/or password. Try again.").showOkay()
        return
      }
      
      CCUserViewModel.validateUserInServer(user: user!)
    }) { (error) in
      SVProgressHUD.dismiss()
      print(error.localizedDescription)
      Alert(title: "Oops!", message: "Something went wrong. Try again later.").showOkay()
    }

  }
  
  
  
  //MARK: - Google SignIn methods
  public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if error == nil {
      let newUser = CCUser(WithGoogleUser: user)
      CCUserViewModel.validateUserInServer(user: newUser)
      CCSessionManager.googleSignOut()
    }else{
      print("Error: \(error.localizedDescription)")
      if error.localizedDescription != "The user canceled the sign-in flow." && error.localizedDescription != "access_denied" {
        Alert(title: "Oops!", message: "Something went wrong in server. Please try again later.").showOkay()
      }
      

    }
  }
  

  
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Error!) {
    if error == nil {
      CCUserViewModel.deleteLoggedUser()
      NavigationManager.goLogin()
    }else{
      print("Error: \(error.localizedDescription)")
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "createNewUserSegue" {
      let nav = segue.destination as! UINavigationController
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

