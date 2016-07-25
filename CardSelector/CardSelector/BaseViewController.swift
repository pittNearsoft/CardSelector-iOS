//
//  BaseViewController.swift
//  CardSelector
//
//  Created by projas on 7/24/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import CoreLocation

class BaseViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if CLLocationManager.authorizationStatus() == .Denied {
      performSegueWithIdentifier("enableLocationSegue", sender: self)
    }
  }
  
}
