//
//  asd.swift
//  CardSelector
//
//  Created by projas on 7/6/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

extension UIView {
  func addShadowEffect(){
    self.layer.shadowColor = UIColor.blackColor().CGColor
    self.layer.shadowOpacity = 0.3
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
  }
  
  func hideViewAnimated() {
    UIView.transitionWithView(self, duration: 0.3, options: .TransitionCrossDissolve, animations: {() -> Void in
      
      self.hidden = true
      
      
      }, completion: nil)
  }
  
  func showViewAnimated() {
    UIView.transitionWithView(self, duration: 0.3, options: .TransitionCrossDissolve, animations: {() -> Void in
      
      self.hidden = false
      
      
      }, completion: nil)
  }
  
  func roundCorners() {
    self.layer.cornerRadius = 5
    self.layer.masksToBounds = true
  }
  
  func lock() {
    if let _ = viewWithTag(10) {
      //View is already locked
    }
    else {
      let lockView = UIView(frame: bounds)
      lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
      lockView.tag = 10
      lockView.alpha = 0.0
      let activity = UIActivityIndicatorView(activityIndicatorStyle: .White)
      activity.hidesWhenStopped = true
      activity.center = lockView.center
      lockView.addSubview(activity)
      activity.startAnimating()
      addSubview(lockView)
      
      UIView.animateWithDuration(0.2) {
        lockView.alpha = 1.0
      }
    }
  }
  
  func unlock() {
    if let lockView = viewWithTag(10) {
      UIView.animateWithDuration(0.2, animations: {
        lockView.alpha = 0.0
      }) { finished in
        lockView.removeFromSuperview()
      }
    }
  }
  
  func fadeOut(duration: NSTimeInterval) {
    UIView.animateWithDuration(duration) {
      self.alpha = 0.0
    }
  }
  
  func fadeIn(duration: NSTimeInterval) {
    UIView.animateWithDuration(duration) {
      self.alpha = 1.0
    }
  }
  
  static func viewFromNibName(name: String) -> UIView? {
    let views = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
    return views.first as? UIView
  }
}
