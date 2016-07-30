//
//  CCUserRouter.swift
//  CardSelector
//
//  Created by projas on 7/21/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

enum CCUserRouter: URLRequestConvertible {
  
  case getUserFromServerWithEmail(email: String)
  case authenticateUserWithEmail(email: String, password: String)
  case saveUserIntoServer(user: CCUser, password: String)
  
  var method: Alamofire.Method{
    switch self {
    case .getUserFromServerWithEmail, .authenticateUserWithEmail, .saveUserIntoServer:
      return .POST
      
    }
  }
  
  var path: String {
    switch self {
    case .getUserFromServerWithEmail:
      return "Profile/User"
      
    case .authenticateUserWithEmail:
      return "Profile/Authenticate"
      
    case .saveUserIntoServer:
      return "Profile"
    }
  }
  
  private var parameters: [String: AnyObject]?{
    switch self {
    case .getUserFromServerWithEmail(let email):
      return [
        "Email": email
      ]
      
    case .authenticateUserWithEmail(let email, let password):
      return [
        "Email": email,
        "UserCredentials": [["LoginProvider": "", "Password": password]]
      ]
      
    case .saveUserIntoServer(let user, let password):
      var userDict: [String: AnyObject] =  [
        "Email" : user.email,
        "FirstName"   : user.firstName,
        "LastName"    : user.lastName
      ]
      
      if user.gender != "" {
        let newGender = "\(user.gender.uppercaseString.characters.first!)"
        userDict["Gender"] = newGender
      }
      
      if user.birthDate != "" {
        userDict["DateOfBirth"] = user.birthDate
      }
      
      
      if password != "" {
        userDict["UserCredentials"] = [["LoginProvider": "Email", "Password": password]]
      }
      
      return userDict
    }
  }
  
  private var encoding: ParameterEncoding?{
    switch self {
    case .getUserFromServerWithEmail, .authenticateUserWithEmail, .saveUserIntoServer:
      return Alamofire.ParameterEncoding.JSON
      
    }
  }
  
  var URLRequest: NSMutableURLRequest{
    let url = APIClient.getFullUrlWithPath(path)
    let mutableURLRequest = NSMutableURLRequest(URL: url!)
    
    mutableURLRequest.HTTPMethod = method.rawValue
    
    if let encoding = self.encoding {
      return encoding.encode(mutableURLRequest, parameters: self.parameters).0
    }
    
    return mutableURLRequest
    
  }
}
