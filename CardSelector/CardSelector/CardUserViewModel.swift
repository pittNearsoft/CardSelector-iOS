//
//  UserViewModel.swift
//  CardSelector
//
//  Created by projas on 6/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import RealmSwift

class CardUserViewModel: NSObject {
  
  static func saveUserIntoReal(user: User) {
    let realm = try! Realm()
    
    try! realm.write({
      realm.add(user)
    })
  }
  
  static func deleteUserFromRealm(user: User) {
    let realm = try! Realm()
    try! realm.write {
      realm.delete(user)
    }
  }
  
  static func getLoggedUser() -> User{
    let realm = try! Realm()
    let user: User? = realm.objects(User).first
    return user!
  }
  
  static func existLoggedUser() -> Bool {
    let realm = try! Realm()
    let user = realm.objects(User).first
    return user != nil
  }
  
}
