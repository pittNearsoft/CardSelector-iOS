//
//  MainViewController.swift
//  CardSelector
//
//  Created by projas on 6/29/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import GoogleSignIn

class MainViewController: UIViewController {

  let sessionManager = SessionManager()
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  let user = CardUserViewModel.getLoggedUser()
  
  
    override func viewDidLoad() {
      super.viewDidLoad()
      userNameLabel.text = user.name
      emailLabel.text = user.email
    }
  
  
  @IBAction func signOut(sender: AnyObject) {
    SessionManager.logOut()
  }

}
