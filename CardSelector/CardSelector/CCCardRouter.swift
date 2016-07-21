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
  case saveCard(card: CCProfileCard, user: CCUser)
  case getProfileCardsFromUser(user: CCUser)
  
  var method: Alamofire.Method{
    switch self {
    case .getAvailableCards:
      return .GET
      
    case .getAvailableCardsFromBank, saveCard, .getProfileCardsFromUser:
      return .POST
      
    }
  }
  
  var path: String{
    switch self {
    case .getAvailableCards, .getAvailableCardsFromBank:
      return "Cards"
      
    case .saveCard:
      return "ProfileCards"
      
    case .getProfileCardsFromUser:
      return "ProfileCards/Cards"
    }
  }
  
  private var parameters: [String: AnyObject]?{
    switch self {
    case .getAvailableCardsFromBank(let bank):
      return [
        "BankId"         : bank.bankId
      ]
      
    case .saveCard(let profileCard, let user):
      
      var dictionary: [String: AnyObject] = [
        //TODO: REMOVE THIS LATER
        "UserProfileId" : 1,
        "CardId"        : profileCard.card!.cardId,
      ]
      
      if profileCard.endingCard != -1 {
        dictionary["EndingCard"] = profileCard.endingCard
      }
      
      if profileCard.interestRate != -1 {
        dictionary["InterestRate"] = profileCard.interestRate
      }
      
      return dictionary
      
    case .getProfileCardsFromUser(let user):
      return [
        //TODO: REMOVE THIS LATER
        "Email" : "javier.eduardo.velarde@gmail.com"
      ]
      
    case .getAvailableCards:
      return nil
    }
  }
  
  private var encoding: ParameterEncoding?{
    switch self {
    case .getAvailableCardsFromBank, .saveCard, .getProfileCardsFromUser:
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
