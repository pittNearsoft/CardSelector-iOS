//
//  MainViewController.swift
//  CardSelector
//
//  Created by projas on 6/29/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import LKAlertController


class ProfileViewController: UIViewController {

  let sessionManager = SessionManager()
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  let user = CCUserViewModel.getLoggedUser()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userNameLabel.text = user!.name
    emailLabel.text = user!.email
  }
  
  
  @IBAction func signOut(sender: AnyObject) {
    ActionSheet()
      .addAction("Cancel")
      .addAction("Sign Out", style: .Default, handler: { _  in
        SessionManager.logOut()
      }).show()
    
    
  }

}
