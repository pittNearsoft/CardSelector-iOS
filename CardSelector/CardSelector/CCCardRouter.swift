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
  case getAvailableCardsFromBank(bank: CCBank)
  
  var method: Alamofire.Method{
    switch self {
    case .getAvailableCards:
      return .GET
      
    case .getAvailableCardsFromBank:
      return .POST
      
    }
  }
  
  var path: String{
    switch self {
    case .getAvailableCards, .getAvailableCardsFromBank:
      return "Cards"
    }
  }
  
  private var parameters: [String: AnyObject]?{
    switch self {
    case .getAvailableCardsFromBank(let bank):
      return [
        "BankId"         : bank.bankId
      ]
      
    case .getAvailableCards:
      return nil
    }
  }
  
  private var encoding: ParameterEncoding?{
    switch self {
    case .getAvailableCardsFromBank:
      return Alamofire.ParameterEncoding.JSON
    case .getAvailableCards:
      return nil
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
