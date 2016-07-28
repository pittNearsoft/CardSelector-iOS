//
//  NewUserViewController.swift
//  CardSelector
//
//  Created by projas on 7/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import Eureka
import Timepiece
import SwiftValidators

class NewUserViewController: FormViewController {
  
  private let mainColor = UIColor(red:0.04, green:0.69, blue:0.92, alpha:1.0)
  private let errorColor = UIColor ( red: 1.0, green: 0.3524, blue: 0.3492, alpha: 1.0 )
  
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
      }.onChange({ row in
        guard row.value != nil else{ return }
        
        let email: String = row.value!
        
        if !Validator.isEmail(email){
          row.cell!.backgroundColor = self.errorColor
        }
        else{
          row.cell!.backgroundColor = .whiteColor()
        }
        
        
      })
      <<< PasswordRow("Password"){ row in
        row.title = "Password"
        row.placeholder = "Enter password"
      }
      <<< PasswordRow("ConfirmPassword"){ row in
        row.title = "Confirm"
        row.placeholder = "Confirm password"
        
        row.disabled = Condition.Function(["Password"], { (form) -> Bool in
          let row: PasswordRow! = form.rowByTag("Password")
          return row.value == nil
        })
        
        
        
      }.onChange({ row in
        guard row.value != nil else{ return }
        let passRow: PasswordRow! = self.form.rowByTag("Password")
        
        if row.value?.compare(passRow.value!) != .OrderedSame {
          row.cell!.backgroundColor = self.errorColor
        }
        else{
          row.cell!.backgroundColor = .whiteColor()
        }
        row.updateCell()
        
      })
      +++ Section("Optional")
      <<< DateInlineRow("Birth"){ row in
        row.title = "Date of birth"
        row.value = NSDate.yesterday()
        
        }.onChange { row in

          //That means, the selected birthday is later than today
          if row.value?.compare(NSDate.yesterday()) == .OrderedDescending {
            row.cell!.backgroundColor = self.errorColor
          }
          else{
            row.cell!.backgroundColor = .whiteColor()
          }
          row.updateCell()
      }
      <<< SegmentedRow<String>("Gender") { row in
        row.title = "Gender"
        row.options = ["Male", "Female"]
        row.value = row.options[0]
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
