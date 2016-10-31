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
import Crashlytics

class NavigationManager {
  
  static func setInitialStoryboard() {
    
    SVProgressHUD.setBackgroundColor(UIColor.clear)
    SVProgressHUD.setDefaultStyle(.custom)
    SVProgressHUD.show()
    if CCUserViewModel.existLoggedUser() {
      let user = CCUserViewModel.getLoggedUser()
      
      CCUserViewModel.getUserProfileWithEmail(email: user!.email,
        completion: { (profile) in
          if profile != nil{
            //Retrieve saved cards
            user!.profileCards = profile!.profileCards
            
            //Now save user in cache
            CCUserViewModel.saveUserIntoUserDefaults(user: user!)

            SVProgressHUD.dismiss()
            goMain()
          }else{
            SVProgressHUD.dismiss()
            Alert(title: "Oops!", message: "Session couldn't be retrieved. Please login again.")
              .addAction("OK", style: .default, handler: { _ in
                goLogin()
              }).show()
          }
          
        },
        onError: { (error) in
          SVProgressHUD.dismiss()
          print(error.localizedDescription)
          Alert(title: "Oops!", message: "Session couldn't be retrieved. Please login again.")
            .addAction("OK", style: .default, handler: { _ in
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
    let app = UIApplication.shared.delegate!
    
    let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: viewControllerId)
    app.window?!.rootViewController = vc
    
    UIView.transition(with: app.window!!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { app.window?!.rootViewController = vc
      }, completion: nil)
  }
  
  static func goLogin(){
    goToStoryboard(storyboardName: "Login", viewControllerId: "NavLoginViewController")
  }
  
  static func goMain(){
    Answers.logCustomEvent(withName: "User logged in", customAttributes: ["time": Date().stringFromFormat("dd/MMM/yyyy h:mm a")])
    goToStoryboard(storyboardName: "Main", viewControllerId: "NavMainViewController")
  }
  
}
