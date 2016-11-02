//
//  CCCardRouter.swift
//  CardSelector
//
//  Created by projas on 7/17/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

enum CCCardRouter: URLRequestConvertible {
  
  func asURLRequest() throws -> URLRequest {
    let url = APIClient.getFullUrlWithPath(path: path)
    var urlRequest = URLRequest(url: url!)
    
    urlRequest.httpMethod = method.rawValue
    
    urlRequest.setValue("Basic QWRtaW46QzRyZEMwbXA0ZHIzOjVFOTA3ODRSRg==", forHTTPHeaderField: "Authorization")
    
    switch self {
    case .getAvailableCardsFromBank, .saveCard, .getProfileCardsFromUser, .deleteCard:
      //urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameters)
      urlRequest = try URLEncoding.httpBody.encode(urlRequest, with: self.parameters)
    
    default:
      break
    }
    
    return urlRequest

  }
  
  case getAvailableCards()
  case getAvailableCardsFromBank(bank: CCBank)
  case saveCard(card: CCProfileCard, user: CCUser)
  case deleteCard(card: CCProfileCard, user: CCUser)
  case getProfileCardsFromUser(user: CCUser)
  
  var method: HTTPMethod{
    switch self {
    case .getAvailableCards:
      return .get
      
    case .getAvailableCardsFromBank, .saveCard, .getProfileCardsFromUser:
      return .post
      
    case .deleteCard:
      return .delete
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
      
    case .deleteCard:
      return "ProfileCards/Delete"
    }
  }
  
  private var parameters: [String: Any]?{
    switch self {
    case .getAvailableCardsFromBank(let bank):
      return [
        "BankId"         : bank.bankId
      ]
      
    case .saveCard(let profileCard, let user):
      
      var dictionary: [String: Any] = [
        "UserProfileId" : user.userId,
        "CardId"        : profileCard.card!.cardId,
      ]
      
      if profileCard.endingCard != -1 {
        dictionary["EndingCard"] = profileCard.endingCard
      }
      
      if profileCard.interestRate != -1 {
        dictionary["InterestRate"] = profileCard.interestRate
      }
      
      if profileCard.cuttOffDay != -1 {
        dictionary["CuttOffDay"] = profileCard.cuttOffDay
      }
      
      return dictionary
      
    case .getProfileCardsFromUser(let user):
      return [
        "Email" : user.email
      ]
      
    case .deleteCard(let profileCard, let user):
      return [
        "UserProfileId" : user.userId,
        "CardId"        : profileCard.card!.cardId
      ]
      
    case .getAvailableCards:
      return nil
    }
  }


}
