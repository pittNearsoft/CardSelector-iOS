//
//  NavigationManager.swift
//  CardSelector
//
//  Created by projas on 6/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class NavigationManager {
  
  static func setInitialStoryboard() {
    
    if CCUserViewModel.existLoggedUser() {
      goMain()
    }else{
      goLogin()
    }
  }
  
  private static func goToStoryboard(storyboardName: String, viewControllerId: String) -> Void{
    let app = UIApplication.sharedApplication().delegate!
    
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier(viewControllerId)
    app.window?!.rootViewController = vc
    
    UIView.transitionWithView(app.window!!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { app.window?!.rootViewController = vc
      }, completion: nil)
  }
  
  static func goLogin(){
    goToStoryboard("Login", viewControllerId: "NavLoginViewController")
  }
  
  static func goMain(){
    goToStoryboard("Main", viewControllerId: "NavMainViewController")
  }
  
}
