//
//  CCCardRouter.swift
//  CardSelector
//
//  Created by projas on 7/17/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

enum CCCardRouter: URLRequestConvertible {
  
  case getAvailableCards()
  
  var method: Alamofire.Method{
    switch self {
    case .getAvailableCards:
      return .GET
      
    }
  }
  
  var path: String{
    switch self {
    case .getAvailableCards:
      return "Cards"
    }
  }

  var URLRequest: NSMutableURLRequest{
    let url = APIClient.getFullUrlWithPath(path)
    let mutableURLRequest = NSMutableURLRequest(URL: url!)
    
    mutableURLRequest.HTTPMethod = method.rawValue
    
    return mutableURLRequest

  }
}
