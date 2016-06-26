//
//  ViewController.swift
//  CardSelector
//
//  Created by projas on 6/26/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let loginButton = FBSDKLoginButton()
    loginButton.center = view.center
    view.addSubview(loginButton)
  }

}

