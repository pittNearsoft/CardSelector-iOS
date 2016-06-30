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
  
  static func saveUserIntoReal(user: CardUser) {
    let realm = try! Realm()
    
    try! realm.write({
      realm.add(user)
    })
  }
  
  static func deleteUserFromRealm(user: CardUser) {
    let realm = try! Realm()
    try! realm.write {
      realm.delete(user)
    }
  }
  
  static func getLoggedUser() -> CardUser{
    let realm = try! Realm()
    let user: CardUser? = realm.objects(CardUser).first
    return user!
  }
  
  static func existLoggedUser() -> Bool {
    let realm = try! Realm()
    let user = realm.objects(CardUser).first
    return user != nil
  }
  
}
