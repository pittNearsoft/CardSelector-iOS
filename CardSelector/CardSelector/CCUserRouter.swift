//
//  CCUserRouter.swift
//  CardSelector
//
//  Created by projas on 7/21/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

enum CCUserRouter: URLRequestConvertible {
  
  func asURLRequest() throws -> URLRequest {
    let url = APIClient.getFullUrlWithPath(path: path)
    var urlRequest = URLRequest(url: url!)
    
    urlRequest.httpMethod = method.rawValue
    urlRequest.setValue("Basic QWRtaW46QzRyZEMwbXA0ZHIzOjVFOTA3ODRSRg==", forHTTPHeaderField: "Authorization")
    
    switch self {
    case .getUserFromServerWithEmail, .authenticateUserWithEmail, .saveUserIntoServer:
      urlRequest = try URLEncoding.httpBody.encode(urlRequest, with: self.parameters)
    }
    
    return urlRequest
  }
  
  case getUserFromServerWithEmail(email: String)
  case authenticateUserWithEmail(email: String, password: String)
  case saveUserIntoServer(user: CCUser, password: String)
  
  var method: HTTPMethod{
    switch self {
    case .getUserFromServerWithEmail, .authenticateUserWithEmail, .saveUserIntoServer:
      return .post
      
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
  
  private var parameters: [String: Any]?{
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
      var userDict: [String: Any] =  [
        "Email" : user.email,
        "FirstName"   : user.firstName,
        "LastName"    : user.lastName
      ]
      
      if user.gender != "" {
        let newGender = "\(user.gender.uppercased().characters.first!)"
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

}
