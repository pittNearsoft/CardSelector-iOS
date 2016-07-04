//
//  CCUser.swift
//  CardSelector
//
//  Created by projas on 7/1/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import GoogleSignIn

class CCUser: NSObject, NSCoding {
  var userID    = ""
  var name      = ""
  var email     = ""
  var imageUrl  = ""
  var provider  = 0
  
  init(userID: String, name: String, email: String, imageUrl: String, provider: Int) {
    self.userID   = userID
    self.name     = name
    self.email    = email
    self.imageUrl = imageUrl
    self.provider = provider
  }
  
  init(WithGoogleUser googleUser: GIDGoogleUser) {
    userID    = googleUser.userID
    //tokenId   = googleUser.authentication.idToken
    name      = googleUser.profile.name
    email     = googleUser.profile.email
    imageUrl  = googleUser.profile.imageURLWithDimension(200).absoluteString
    provider = SignInType.Google.rawValue
  }
  
  init(WithFacebookUser facebookUser: [String: AnyObject]) {
    userID    = facebookUser["id"] as! String
    name      = facebookUser["name"] as! String
    email     = facebookUser["email"] as! String
    provider = SignInType.Facebook.rawValue
  }
  
  init(WithEmail email: String) {
    userID = NSUUID().UUIDString
    name = "projas"
    self.email = email
    provider = SignInType.Email.rawValue
  }
  
  convenience required init?(coder decoder: NSCoder) {
    guard let userID    = decoder.decodeObjectForKey("userID") as? String,
          let name      = decoder.decodeObjectForKey("name") as? String,
          let email     = decoder.decodeObjectForKey("email") as? String,
          let imageUrl  = decoder.decodeObjectForKey("imageUrl") as? String,
          let provider  = decoder.decodeObjectForKey("provider") as? Int
      else{ return nil }
    
    self.init(userID: userID, name: name, email: email, imageUrl: imageUrl, provider: provider)
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.userID, forKey: "userID")
    coder.encodeObject(self.name, forKey: "name")
    coder.encodeObject(self.email, forKey: "email")
    coder.encodeObject(self.imageUrl, forKey: "imageUrl")
    coder.encodeObject(self.provider, forKey: "provider")
  }
  
}
