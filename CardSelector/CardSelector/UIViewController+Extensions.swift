//
//  UIViewController+Extensions.swift
//  CardSelector
//
//  Created by projas on 7/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  func hideKeyboard() {
    view.endEditing(true)
  }
}