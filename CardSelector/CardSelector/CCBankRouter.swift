//
//  CCBankRouter.swift
//  CardSelector
//
//  Created by projas on 7/19/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

enum CCBankRouter: URLRequestConvertible {
  
  
  func asURLRequest() throws -> URLRequest {
    let url = APIClient.getFullUrlWithPath(path: path)
    var urlRequest = URLRequest(url: url!)
    
    urlRequest.httpMethod = method.rawValue
    urlRequest.setValue("Basic QWRtaW46QzRyZEMwbXA0ZHIzOjVFOTA3ODRSRg==", forHTTPHeaderField: "Authorization")
    
    
    return urlRequest
  }
  
  case getAvailableBanks()
  
  var method: HTTPMethod{
    switch self {
    case .getAvailableBanks:
      return .get
      
    }
  }
  
  var path: String{
    switch self {
    case .getAvailableBanks:
      return "Banks"
    }
  }
  

  
}
