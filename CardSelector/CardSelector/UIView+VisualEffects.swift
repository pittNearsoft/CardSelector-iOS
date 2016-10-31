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
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.3
    self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
  }
  
  func hideViewAnimated() {
    UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {() -> Void in
      
      self.isHidden = true
      
      
      }, completion: nil)
  }
  
  func showViewAnimated() {
    UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {() -> Void in
      
      self.isHidden = false
      
      
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
      let activity = UIActivityIndicatorView(activityIndicatorStyle: .white)
      activity.hidesWhenStopped = true
      activity.center = lockView.center
      lockView.addSubview(activity)
      activity.startAnimating()
      addSubview(lockView)
      
      UIView.animate(withDuration: 0.2) {
        lockView.alpha = 1.0
      }
    }
  }
  
  func unlock() {
    if let lockView = viewWithTag(10) {
      UIView.animate(withDuration: 0.2, animations: {
        lockView.alpha = 0.0
      }) { finished in
        lockView.removeFromSuperview()
      }
    }
  }
  
  func fadeOut(duration: TimeInterval) {
    UIView.animate(withDuration: duration) {
      self.alpha = 0.0
    }
  }
  
  func fadeIn(duration: TimeInterval) {
    UIView.animate(withDuration: duration) {
      self.alpha = 1.0
    }
  }
  
  static func viewFromNibName(name: String) -> UIView? {
    let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
    return views?.first as? UIView
  }
}
