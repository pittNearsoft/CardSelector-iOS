//
//  CCBankRouter.swift
//  CardSelector
//
//  Created by projas on 7/19/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

enum CCBankRouter: URLRequestConvertible {
  
  case getAvailableBanks()
  
  var method: Alamofire.Method{
    switch self {
    case .getAvailableBanks:
      return .GET
      
    }
  }
  
  var path: String{
    switch self {
    case .getAvailableBanks:
      return "Banks"
    }
  }
  

  
  var URLRequest: NSMutableURLRequest{
    let url = APIClient.getFullUrlWithPath(path)
    let mutableURLRequest = NSMutableURLRequest(URL: url!)
    
    mutableURLRequest.HTTPMethod = method.rawValue
    
    
    return mutableURLRequest
    
  }
}
