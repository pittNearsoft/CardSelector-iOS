//
//  CCSuggestionRouter.swift
//  CardSelector
//
//  Created by projas on 7/23/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

enum CCSuggestionRouter: URLRequestConvertible {
  
  case getSuggestionsWithUser(user: CCUser, merchant: CCPlace)
  
  var method: Alamofire.Method{
    switch self {
    case .getSuggestionsWithUser:
      return .POST
      
    }
  }
  
  var path: String{
    switch self {
    case .getSuggestionsWithUser:
      return "ProfileCards/Suggestion"
    }
  }
  
  private var parameters: [String: AnyObject]?{
    switch self {
    case .getSuggestionsWithUser(let user, let merchant):
      return [
        "UserProfileId"  : user.userId,
        //TODO:CHANGE THIS LATER
        "Merchant"       : merchant.name
      ]
      
    }
  }
  
  private var encoding: ParameterEncoding?{
    switch self {
    case .getSuggestionsWithUser:
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
