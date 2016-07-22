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
  
  func saveCard(card: CCProfileCard, user: CCUser, completion: (sucess: String)-> Void, onError: (error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.saveCard(card: card, user: user))
      .CCresponseJSON { (response) in
        guard let actualResponse = response.response else{
          onError(error: Error.error(code: 404, failureReason: "Server couldn't respond"))
          return
        }
        
        switch actualResponse.statusCode{
        case 200:
          completion(sucess: "ok")
        default:
          onError(error: Error.error(code: actualResponse.statusCode, failureReason: "Server error"))
        }
    }
  }
  
  func deleteCard(card: CCProfileCard, user: CCUser, completion: (sucess: String)-> Void, onError: (error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.deleteCard(card: card, user: user))
      .CCresponseJSON { (response) in
        
        guard let actualResponse = response.response else{
          onError(error: Error.error(code: 404, failureReason: "Server couldn't respond"))
          return
        }
        
        switch actualResponse.statusCode{
        case 200:
          completion(sucess: "ok")
        default:
          onError(error: Error.error(code: actualResponse.statusCode, failureReason: "Server error"))
        }
    }
  }
  
  func getProfileCardsFromUser(user: CCUser, completion: (jsonCards: [AnyObject])-> Void, onError: (error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.getProfileCardsFromUser(user: user))
      .CCresponseJSON { (response) in
        switch response.result{
        case .Success(let JSON):
          
          if let message = JSON["Message"] as? String{
            
            if message == "No Data" {
              completion(jsonCards: [])
              return 
            }
            
          }
          
          guard let result = JSON["UserProfileCards"] as? [AnyObject] else{
            onError(error: Error.error(code: -1, failureReason: "Bad json received"))
            return
          }
          completion(jsonCards: result)
          
        case .Failure(let error):
          onError(error: error)
        }
    }
  }

}
