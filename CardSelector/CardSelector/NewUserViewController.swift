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
import LKAlertController
import SVProgressHUD

class NewUserViewController: FormViewController {
  
  private let mainColor = UIColor(red:0.04, green:0.69, blue:0.92, alpha:1.0)
  private let errorColor = UIColor ( red: 1.0, green: 0.3524, blue: 0.3492, alpha: 1.0 )
  var delegate: NewUserViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    form +++ Section("Basic")
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
          
          if !Validators.isEmail()(email){
            row.cell!.backgroundColor = self.errorColor
          }
          else{
            row.cell!.backgroundColor = .white
          }
          
          
        })
      <<< PasswordRow("Password"){ row in
        row.title = "Password"
        row.placeholder = "Enter password"
      }
      <<< PasswordRow("ConfirmPassword"){ row in
        row.title = "Confirm"
        row.placeholder = "Confirm password"
        
        row.disabled = Condition.function(["Password"], { (form) -> Bool in
          let row: PasswordRow! = form.rowBy(tag: "Password")
          return row.value == nil
        })
        
        
        
        }.onChange({ row in
          guard row.value != nil else{ return }
          let passRow: PasswordRow! = self.form.rowBy(tag: "Password")
          
          if row.value?.compare(passRow.value!) != .orderedSame {
            row.cell!.backgroundColor = self.errorColor
          }
          else{
            row.cell!.backgroundColor = .white
          }
          row.updateCell()
          
        })
//      +++ Section("Additional")
//      <<< DateInlineRow("Birth"){ row in
//        row.title = "Date of birth"
//        row.value = Date.yesterday()
//        
//        }.onChange { row in
//          
//          //That means, the selected birthday is later than today
//          if row.value?.compare(Date.yesterday()) == .orderedDescending {
//            row.cell!.backgroundColor = self.errorColor
//          }
//          else{
//            row.cell!.backgroundColor = .white
//            row.updateCell()
//          }
//      }
//      <<< SegmentedRow<String>("Gender") { row in
//        row.title = "Gender"
//        row.options = ["Male", "Female"]
//        row.value = row.options[0]
//      }
    
    
      customizeNavigationBar()
    }
    
    func customizeNavigationBar() {
      self.navigationController?.navigationBar.tintColor = mainColor
      self.navigationController?.navigationBar.barTintColor = mainColor
      self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
      
    }
    
    @IBAction func cancelNewUser(_ sender: AnyObject) {
      dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func saveNewUser(_ sender: AnyObject) {
      let values = form.values()
      
      if isDataCorrect(values: values) {
        
        
        let firstName = values["FirstName"] as! String
        let lastName = values["LastName"] as! String
        let email = values["Email"] as! String
        //var gender = values["Gender"] as! String
        //gender = (gender == "Male") ? "M" : "F"
        let password = values["Password"] as! String
        //let birth = values["Birth"] as! Date
        
        let user = CCUser(userDictionary: [
          "firstName"   : firstName,
          "lastName"    : lastName,
          "email"       : email,
          //"gender"      : nil,
          //"birthDate"   : nil,
          
          //Extra info required
          "providerId" : "",
          "userId": 0,
          "imageUrl": "",
          "provider": 0,
          "profileCards": [CCProfileCard]()
          ])
        
        Alert(message: "Do you want to create a new user?")
        .addAction("Cancel")
        .addAction("Create", style: .default, handler: { _ in
          SVProgressHUD.show()
          CCUserViewModel.saveUserIntoServer(user: user, password: password, completion: { (profile) in
            SVProgressHUD.dismiss()
            Alert(title: "Done!", message: "Data was saved. Now you can sign in with your email: \(profile!.email)")
              .addAction("OK", style: .default, handler: { _ in
                self.delegate?.didSaveNewUserWithEmail(email: profile!.email)
                self.dismiss(animated: true, completion: nil)
              })
              .show()
            }, onError: { (error) in
              SVProgressHUD.dismiss()
              Alert(title: "Oops!", message: "Something went wrong saving data. Please try again later.").showOkay()
          })
        }).show()
        
      }
    }
    
    func isDataCorrect(values: [String: Any?]) -> Bool{
      
      if values["FirstName"]! == nil {
        Alert(title: "Oops!", message: "First name field is empty.").showOkay()
        return false
      }
      
      if values["LastName"]! == nil {
        Alert(title: "Oops!", message: "Last name field is empty.").showOkay()
        return false
      }
      
      if values["Email"]! == nil {
        Alert(title: "Oops!", message: "Email field is empty").showOkay()
        return false
      }
      
      
      if !Validators.isEmail()(values["Email"] as! String) {
        Alert(title: "Oops!", message: "Email format is not correct").showOkay()
        return false
      }
      
      if values["Password"]! == nil {
        Alert(title: "Oops!", message: "Password field is empty").showOkay()
        return false
      }
      
      let password = values["Password"] as! String
      if password.characters.count < 6 {
        Alert(title: "Oops!", message: "Password is too short. Must be at least 6 characters").showOkay()
        return false
      }
      
      
      if values["ConfirmPassword"]! == nil {
        Alert(title: "Oops!", message: "Password confirmation field is empty").showOkay()
        return false
      }
      
      
      let passwordConfirmation = values["ConfirmPassword"] as! String
      if passwordConfirmation != password {
        Alert(title: "Oops!", message: "Password confirmation does not match with actual password").showOkay()
        return false
      }
      
      
//      let dateOfBirth = values["Birth"] as! Date
//      if dateOfBirth > Date.yesterday() {
//        Alert(title: "Oops!", message: "Date of birth is incorrect.").showOkay()
//        return false
//      }
      
      
      return true
      
      
    }
    
  }
  


protocol NewUserViewControllerDelegate {
    func didSaveNewUserWithEmail(email: String)
}
