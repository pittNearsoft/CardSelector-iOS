//
//  User.swift
//  CardSelector
//
//  Created by projas on 6/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import RealmSwift
import Google
import GoogleSignIn

class CardUser: Object {
  dynamic var userID = ""
  dynamic var tokenId = ""
  dynamic var name = ""
  dynamic var email = ""
  dynamic var imageUrl = ""
  
  convenience init(WithGoogleUser googleUser: GIDGoogleUser) {
    self.init()
    userID    = googleUser.userID
    tokenId   = googleUser.authentication.idToken
    name      = googleUser.profile.name
    email     = googleUser.profile.email
    imageUrl  = googleUser.profile.imageURLWithDimension(200).absoluteString
  }
  
  convenience init(WithFacebookUser facebookUser: [String: AnyObject]) {
    self.init()
    userID    = facebookUser["id"] as! String
    name      = facebookUser["name"] as! String
    email     = facebookUser["email"] as! String
  }
  
  convenience init(WithEmail email: String) {
    self.init()
    userID = NSUUID().UUIDString
    name = "projas"
    self.email = email
  }
  
  override static func primaryKey() -> String?{
    return "userID"
  }
}
