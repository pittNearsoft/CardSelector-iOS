//
//  EmailViewController.swift
//  CardSelector
//
//  Created by projas on 6/30/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import LKAlertController

class EmailViewController: UIViewController {

  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func emailSignIn(sender: AnyObject) {
    if emailTextField.text == "projas@nearsoft.com"  && passwordTextField.text == "welcome1"{
      
      SessionManager.emailSignIn(emailTextField.text!)
    }else{
      Alert(title: "Ops!", message: "Invalid email and/or password. Try again.").showOkay()
    }
  }

}
