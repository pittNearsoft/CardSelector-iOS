//
//  CCCardService.swift
//  CardSelector
//
//  Created by projas on 7/17/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

class CCCardService {
  private let apiClient = APIClient()
  
  func getAvailableCards(completion: (jsonCards: [AnyObject])-> Void, onError: (error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.getAvailableCards())
      .CCresponseJSON { (response) in
        switch response.result{
        case .Success(let JSON):
          guard let result = JSON as? [AnyObject] else{
            onError(error: Error.error(code: -1, failureReason: "Bad json received"))
            return
          }
          completion(jsonCards: result)
          
        case .Failure(let error):
          onError(error: error)
        }
    }
  }
  
  func getAvailableCardsFromBank(bank: CCBank, completion: (jsonCards: [AnyObject])-> Void, onError: (error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.getAvailableCardsFromBank(bank: bank))
      .CCresponseJSON { (response) in
        switch response.result{
        case .Success(let JSON):
          guard let result = JSON as? [AnyObject] else{
            onError(error: Error.error(code: -1, failureReason: "Bad json received"))
            return
          }
          completion(jsonCards: result)
          
        case .Failure(let error):
          onError(error: error)
        }
    }

  }
  
  func saveCard(card: CCCard, user: CCUser, completion: (sucess: String)-> Void, onError: (error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.saveCard(card: card, user: user))
      .CCresponseJSON { (response) in
        switch response.result{
        case .Success:
          completion(sucess: "ok")
          
        case .Failure(let error):
          onError(error: error)
        }
    }
  }

}
