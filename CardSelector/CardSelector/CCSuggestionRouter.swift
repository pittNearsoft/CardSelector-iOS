//
//  CCSuggestionRouter.swift
//  CardSelector
//
//  Created by projas on 7/23/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

enum CCSuggestionRouter: URLRequestConvertible {
  /// Returns a URL request or throws if an `Error` was encountered.
  ///
  /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
  ///
  /// - returns: A URL request.
  public func asURLRequest() throws -> URLRequest {
    let url = APIClient.getFullUrlWithPath(path: path)
    var urlRequest = URLRequest(url: url!)
    
    urlRequest.httpMethod = method.rawValue
    urlRequest.setValue("Basic QWRtaW46QzRyZEMwbXA0ZHIzOjVFOTA3ODRSRg==", forHTTPHeaderField: "Authorization")
    
    switch self {
    case .getSuggestionsWithUser:
      urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameters)
    }
    
    return urlRequest
  }

  
  case getSuggestionsWithUser(user: CCUser, merchant: CCPlace)
  
  var method: HTTPMethod{
    switch self {
    case .getSuggestionsWithUser:
      return .post
      
    }
  }
  
  var path: String{
    switch self {
    case .getSuggestionsWithUser:
      return "ProfileCards/Suggestion"
    }
  }
  
  private var parameters: [String: Any]?{
    switch self {
    case .getSuggestionsWithUser(let user, let merchant):
      return [
        "UserProfileId"  : user.userId,
        "Merchant"       : merchant.name
      ]
      
    }
  }
  
  
}
