//
//  NavigationManager.swift
//  CardSelector
//
//  Created by projas on 6/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class NavigationManager {
  
  private static func goToStoryboard(storyboardName: String, viewControllerId: String) -> Void{
    let app = UIApplication.sharedApplication().delegate!
    
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier(viewControllerId)
    app.window?!.rootViewController = vc
    
    UIView.transitionWithView(app.window!!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { app.window?!.rootViewController = vc
      }, completion: nil)
  }
  
  func goLogin(){
    NavigationManager.goToStoryboard("Login", viewControllerId: "LoginViewController")
  }
  
  func goMain(){
    NavigationManager.goToStoryboard("Main", viewControllerId: "MyEventsViewController")
  }
  
}
