//
//  CCUser.swift
//  CardSelector
//
//  Created by projas on 7/1/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import GoogleSignIn
import ObjectMapper


class CCUser: NSObject, NSCoding {
  //Googgle or Facebook
  dynamic var providerId          = ""
  
  //CC Id
  var userId              = 0
  var firstName           = ""
  var lastName            = ""
  var email               = ""
//  var gender              = ""
//  
//  var birthDate           = ""
  
  var imageUrl            = ""
  var provider            = 0
  var profileCards: [CCProfileCard] = []
  
  
  init(userDictionary: [String: Any]) {
    self.providerId   = userDictionary["providerId"] as! String
    self.userId       = userDictionary["userId"] as! Int
    self.firstName    = userDictionary["firstName"] as! String
    self.lastName     = userDictionary["lastName"] as! String
    self.email        = userDictionary["email"] as! String
//    self.gender       = userDictionary["gender"] as! String
//    self.birthDate    = userDictionary["birthDate"] as! String
    
    self.imageUrl     = userDictionary["imageUrl"] as! String
    self.provider     = userDictionary["provider"] as! Int
    self.profileCards = userDictionary["profileCards"] as! [CCProfileCard]
  }
  
  init(WithGoogleUser googleUser: GIDGoogleUser) {
    providerId    = googleUser.userID
    firstName = googleUser.profile.givenName
    lastName  = googleUser.profile.familyName
    email     = googleUser.profile.email
    
    
    imageUrl  = googleUser.profile.imageURL(withDimension: 200).absoluteString
    provider = SignInType.Google.rawValue
  }
  
  init(WithFacebookUser facebookUser: [String: AnyObject]) {
    providerId    = facebookUser["id"] as! String
    firstName = facebookUser["first_name"] as! String
    lastName  = facebookUser["last_name"] as! String
    email     = facebookUser["email"] as! String
    
//    if facebookUser["gender"] != nil {
//      gender = facebookUser["gender"] as! String
//    }
//    
//    if facebookUser["birthday"]  != nil {
//      birthDate = facebookUser["birthday"] as! String
//    }
    
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
    guard let providerId    = decoder.decodeObject(forKey: "providerId") as? String,
          let userId        = decoder.decodeObject(forKey: "userId") as? Int,
          let firstName     = decoder.decodeObject(forKey: "firstName") as? String,
          let lastName      = decoder.decodeObject(forKey: "lastName") as? String,
          let email         = decoder.decodeObject(forKey: "email") as? String,
          let gender        = decoder.decodeObject(forKey: "gender") as? String,
          let birthDate     = decoder.decodeObject(forKey: "birthDate") as? String,
      
          let imageUrl      = decoder.decodeObject(forKey: "imageUrl") as? String,
          let provider      = decoder.decodeObject(forKey: "provider") as? Int,
          let profileCards  = decoder.decodeObject(forKey: "profileCards") as? [CCProfileCard]
      else{ return nil }
    
    let dictionary: [String : Any] = [
      "providerId"    : providerId,
      "userId"        : userId,
      "firstName"     : firstName,
      "lastName"      : lastName,
      "email"         : email,
      "gender"        : gender,
      "birthDate"     : birthDate,
      
      "imageUrl"      : imageUrl,
      "provider"      : provider,
      "profileCards"  : profileCards
    ]
    
    self.init(userDictionary: dictionary)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.providerId, forKey: "providerId")
    aCoder.encode(self.userId,     forKey: "userId")
    aCoder.encode(self.firstName,  forKey: "firstName")
    aCoder.encode(self.lastName,   forKey: "lastName")
    aCoder.encode(self.email,      forKey: "email")
//    aCoder.encode(self.gender,     forKey: "gender")
//    aCoder.encode(self.birthDate,  forKey: "birthDate")
    
    aCoder.encode(self.imageUrl,   forKey: "imageUrl")
    aCoder.encode(self.provider,   forKey: "provider")
    aCoder.encode(self.profileCards, forKey: "profileCards")
  }
  
  
  required init?(map: Map) {

  }
  
}

extension CCUser: Mappable{

  func mapping(map: Map) {
    userId        <- map["Id"]
    email         <- map["Email"]
    firstName     <- map["FirstName"]
    lastName      <- map["LastName"]
//    birthDate     <- map["DateOfBirth"]
//    gender        <- map["Gender"]
    profileCards  <- map["UserProfileCards"]
    imageUrl      <- map["ImageUrl"]
  }
}
