//
//  NewUserViewController.swift
//  CardSelector
//
//  Created by projas on 7/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import Eureka

class NewUserViewController: FormViewController {
  
  private let mainColor = UIColor(red:0.04, green:0.69, blue:0.92, alpha:1.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    form +++ Section("Required")
      <<< NameRow("FirstName"){ row in
        row.title = "First Name"
        row.placeholder = "Enter first name"
      }
      <<< NameRow("LastName"){ row in
        row.title = "Last Name"
        row.placeholder = "Enter last name"
      }
      <<< EmailRow("Email"){ row in
        row.title = "Email"
        row.placeholder = "Enter your email"
        row.useFormatterDuringInput = true
      }
      <<< PasswordRow("Password"){ row in
        row.title = "Password"
        row.placeholder = "Enter password"
      }
      <<< PasswordRow("ConfirmPassword"){ row in
        row.title = "Confirm"
        row.placeholder = "Confirm password"
      }
      +++ Section("Optional")
      <<< DateInlineRow("Birth"){ row in
        row.title = "Date of birth"
        row.value = NSDate()
        
      }
      <<< SegmentedRow<String>("Gender") { row in
        row.title = "Gender"
        row.options = ["Male", "Female"]
    }
    
    customizeNavigationBar()
  }
  
  private func customizeNavigationBar() {
    self.navigationController?.navigationBar.tintColor = mainColor
    self.navigationController?.navigationBar.barTintColor = mainColor
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    
  }
  
  @IBAction func cancelNewUser(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}
