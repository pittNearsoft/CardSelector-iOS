//
//  NavigationManager.swift
//  CardSelector
//
//  Created by projas on 6/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import LKAlertController
import SVProgressHUD

class NavigationManager {
  
  static func setInitialStoryboard() {
    
    SVProgressHUD.show()
    if CCUserViewModel.existLoggedUser() {
      let user = CCUserViewModel.getLoggedUser()
      
      CCUserViewModel.getUserProfileWithEmail(user!.email,
        completion: { (profile) in
          if profile != nil{
            //Retrieve saved cards
            user!.profileCards = profile!.profileCards
            
            //Now save user in cache
            CCUserViewModel.saveUserIntoUserDefaults(user!)

            SVProgressHUD.dismiss()
            goMain()
          }else{
            SVProgressHUD.dismiss()
            Alert(title: "Ops!", message: "Session couldn't be retrieved. Please login again.")
              .addAction("OK", style: .Default, handler: { _ in
                goLogin()
              }).show()
          }
          
        },
        onError: { (error) in
          SVProgressHUD.dismiss()
          print(error.localizedDescription)
          Alert(title: "Ops!", message: "Session couldn't be retrieved. Please login again.")
            .addAction("OK", style: .Default, handler: { _ in
              goLogin()
            }).show()
        }
      )
      
    }else{
      SVProgressHUD.dismiss()
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
