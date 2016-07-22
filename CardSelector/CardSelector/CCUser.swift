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
  var userId    = ""
  var firstName = ""
  var lastName  = ""
  var email     = ""
  var gender    = ""
  var birthDate = ""
  
  var imageUrl  = ""
  var provider  = 0
  var profileCards: [CCProfileCard] = []
  
  
  init(userDictionary: [String: AnyObject]) {
    self.userId     = userDictionary["userId"] as! String
    self.firstName  = userDictionary["firstName"] as! String
    self.lastName   = userDictionary["lastName"] as! String
    self.email      = userDictionary["email"] as! String
    self.gender     = userDictionary["gender"] as! String
    self.birthDate  = userDictionary["birthDate"] as! String
    
    self.imageUrl   = userDictionary["imageUrl"] as! String
    self.provider   = userDictionary["provider"] as! Int
  }
  
  init(WithGoogleUser googleUser: GIDGoogleUser) {
    userId    = googleUser.userID
    firstName = googleUser.profile.givenName
    lastName  = googleUser.profile.familyName
    email     = googleUser.profile.email
    
    
    imageUrl  = googleUser.profile.imageURLWithDimension(200).absoluteString
    provider = SignInType.Google.rawValue
  }
  
  init(WithFacebookUser facebookUser: [String: AnyObject]) {
    userId    = facebookUser["id"] as! String
    firstName = facebookUser["first_name"] as! String
    lastName  = facebookUser["last_name"] as! String
    email     = facebookUser["email"] as! String

    if facebookUser["gender"] != nil {
      gender = facebookUser["gender"] as! String
    }
    
    if facebookUser["birthday"] != nil {
      birthDate = facebookUser["birthday"] as! String
    }
    
    //imageUrl = facebookUser["picture"]!["data"]!?["url"]! as! String
    provider  = SignInType.Facebook.rawValue
  }
  
  init(WithEmail email: String) {
    //TODO: FIX THIS
//    userID = NSUUID().UUIDString
//    name = "projas"
//    self.email = email
//    provider = SignInType.Email.rawValue
  }
  
  convenience required init?(coder decoder: NSCoder) {
    guard let userId      = decoder.decodeObjectForKey("userId") as? String,
          let firstName   = decoder.decodeObjectForKey("firstName") as? String,
          let lastName    = decoder.decodeObjectForKey("lastName") as? String,
          let email       = decoder.decodeObjectForKey("email") as? String,
          let gender      = decoder.decodeObjectForKey("gender") as? String,
          let birthDate   = decoder.decodeObjectForKey("birthDate") as? String,
      
          let imageUrl    = decoder.decodeObjectForKey("imageUrl") as? String,
          let provider    = decoder.decodeObjectForKey("provider") as? Int
      else{ return nil }
    
    let dictionary = [
      "userId": userId,
      "firstName" : firstName,
      "lastName"  : lastName,
      "email"     : email,
      "gender"    : gender,
      "birthDate" : birthDate,
      
      "imageUrl"  : imageUrl,
      "provider"  : provider
    ]
    
    self.init(userDictionary: dictionary as! [String : AnyObject] )
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.userId,     forKey: "userId")
    coder.encodeObject(self.firstName,  forKey: "firstName")
    coder.encodeObject(self.lastName,   forKey: "lastName")
    coder.encodeObject(self.email,      forKey: "email")
    coder.encodeObject(self.gender,     forKey: "gender")
    coder.encodeObject(self.birthDate,  forKey: "birthDate")
    
    coder.encodeObject(self.imageUrl,   forKey: "imageUrl")
    coder.encodeObject(self.provider,   forKey: "provider")
  }
  
}
