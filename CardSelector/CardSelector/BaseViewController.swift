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
  
  private let mainColor = UIColor(red:0.04, green:0.69, blue:0.92, alpha:1.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customizeNavigationBar()
    customizeTabBar()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if CLLocationManager.authorizationStatus() == .Denied {
      performSegueWithIdentifier("enableLocationSegue", sender: self)
    }
  }
  
  
  private func customizeNavigationBar() {
    self.navigationController?.navigationBar.tintColor = mainColor
    self.navigationController?.navigationBar.barTintColor = mainColor
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

  }
  
  private func customizeTabBar() {
    self.tabBarController?.tabBar.barTintColor = mainColor
    self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
    
  }
  
}
