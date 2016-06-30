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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  
  @IBAction func signOut(sender: AnyObject) {
    SessionManager.logOut()
  }

}
