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
  case saveCard(card: CCCard, user: CCUser)
  
  var method: Alamofire.Method{
    switch self {
    case .getAvailableCards:
      return .GET
      
    case .getAvailableCardsFromBank, saveCard:
      return .POST
      
    }
  }
  
  var path: String{
    switch self {
    case .getAvailableCards, .getAvailableCardsFromBank:
      return "Cards"
      
    case .saveCard:
      return "ProfileCards"
    }
  }
  
  private var parameters: [String: AnyObject]?{
    switch self {
    case .getAvailableCardsFromBank(let bank):
      return [
        "BankId"         : bank.bankId
      ]
      
    case .saveCard(let card, let user):
      return [
        //TODO: REMOVE THIS LATER
        "UserProfileId" : 1,
        "CardId"        : card.cardId,
        "EndingCard"    : card.ending,
        "InterestRate"  : card.interestRate
      ]
      
    case .getAvailableCards:
      return nil
    }
  }
  
  private var encoding: ParameterEncoding?{
    switch self {
    case .getAvailableCardsFromBank, .saveCard:
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
