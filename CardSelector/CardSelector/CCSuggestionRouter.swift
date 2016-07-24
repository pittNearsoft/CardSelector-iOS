//
//  CCSuggestionRouter.swift
//  CardSelector
//
//  Created by projas on 7/23/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

enum CCSuggestionRouter: URLRequestConvertible {
  
  case getSuggestions(user: CCUser, merchant: String)
  
  var method: Alamofire.Method{
    switch self {
    case .getSuggestions:
      return .POST
      
    }
  }
  
  var path: String{
    switch self {
    case .getSuggestions:
      return "ProfileCards/Suggestion"
    }
  }
  
  private var parameters: [String: AnyObject]?{
    switch self {
    case .getSuggestions(let user, let merchant):
      return [
        "UserProfileId"  : user.userId,
        //TODO:CHANGE THIS LATER
        "Merchant"       : "Starbucks"
      ]
      
    }
  }
  
  private var encoding: ParameterEncoding?{
    switch self {
    case .getSuggestions:
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
