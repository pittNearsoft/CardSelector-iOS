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
  
  func getAvailableCards(completion: @escaping (_ jsonCards: [[String: AnyObject]])-> Void, onError: @escaping (_ error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.getAvailableCards())
      .responseJSON { (response) in
        switch response.result{
        case .success(let JSON):
          guard let result = JSON as? [[String: AnyObject]] else{
            onError(NSError(domain: "com.kompi", code: -1, userInfo: ["reason": "Bad json received"]))
            return
          }
          completion(result)
          
        case .failure(let error):
          onError(error as NSError)
        }
    }
  }
  
  func getAvailableCardsFromBank(bank: CCBank, completion: @escaping (_ jsonCards: [[String: AnyObject]])-> Void, onError: @escaping (_ error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.getAvailableCardsFromBank(bank: bank))
      .responseJSON { (response) in
        switch response.result{
        case .success(let JSON):
          guard let result = JSON as? [[String: AnyObject]] else{
            onError(NSError(domain: "com.kompi", code: -1, userInfo: ["reason": "Bad json received"]))
            return
          }
          completion(result)
          
        case .failure(let error):
          onError(error as NSError)
        }
    }

  }
  
  func saveCard(card: CCProfileCard, user: CCUser, completion: @escaping (_ sucess: String)-> Void, onError: @escaping (_ error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.saveCard(card: card, user: user))
      .responseJSON { (response) in
        guard let actualResponse = response.response else{
          onError(NSError(domain: "com.kompi", code: 404, userInfo: ["reason": "Server couldn't respond"]))
          
          return
        }
        
        switch actualResponse.statusCode{
        case 200:
          completion("ok")
        default:
          onError(NSError(domain: "com.kompi", code: actualResponse.statusCode, userInfo: ["reason": "Server error"]))
        }
    }
  }
  
  func deleteCard(card: CCProfileCard, user: CCUser, completion: @escaping (_ sucess: String)-> Void, onError: @escaping (_ error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.deleteCard(card: card, user: user))
      .responseJSON { (response) in
        
        guard let actualResponse = response.response else{
          onError(NSError(domain: "com.kompi", code: 404, userInfo: ["reason": "Server couldn't respond"]))
          return
        }
        
        switch actualResponse.statusCode{
        case 200:
          completion("ok")
        default:
          onError(NSError(domain: "com.kompi", code: actualResponse.statusCode, userInfo: ["reason": "Server error"]))
        }
    }
  }
  
  func getProfileCardsFromUser(user: CCUser, completion: @escaping (_ jsonCards: [[String: AnyObject]])-> Void, onError: @escaping (_ error: NSError)->Void) {
    apiClient.manager.request(CCCardRouter.getProfileCardsFromUser(user: user))
      .responseJSON { (response) in
        switch response.result{
        case .success(let JSON as AnyObject):
          
          if let message = JSON["Message"] as? String{
            
            if message == "No Data" {
              completion([])
              return 
            }
            
          }
          
          guard let result = JSON["UserProfileCards"] as? [[String: AnyObject]] else{
            onError(NSError(domain: "com.kompi", code: -1, userInfo: ["reason": "Bad json received"]))
            return
          }
          completion(result)
          
        case .failure(let error):
          onError(error as NSError)
          
        default:
          break
        }
    }
  }

}
