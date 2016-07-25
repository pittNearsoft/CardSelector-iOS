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
    
    self.tabBarController?.viewControllers![0].tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "dashboard")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "dashboard"))
    
    self.tabBarController?.viewControllers![1].tabBarItem = UITabBarItem(title: "My Cards", image: UIImage(named: "credit-cards")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "credit-cards"))
    
    self.tabBarController?.viewControllers![2].tabBarItem = UITabBarItem(title: "My Cards", image: UIImage(named: "user")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "user"))
    
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
