//
//  UIView+UITextField.swift
//  CardSelector
//
//  Created by projas on 7/29/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

extension UITextField {
  func addDoneButtonOnKeyboard()
  {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
    doneToolbar.barStyle = .Default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(doneButtonAction))
    
    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)
    
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    doneToolbar.backgroundColor = UIColor.whiteColor()
    
    self.inputAccessoryView = doneToolbar
    
  }
  
  func doneButtonAction()
  {
    self.resignFirstResponder()
  }
}
