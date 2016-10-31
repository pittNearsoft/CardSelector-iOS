//
//  CCCardViewModel.swift
//  CardSelector
//
//  Created by projas on 7/17/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCCardViewModel {
  let cardService = CCCardService()
  
  func getAvailableCards(completion: @escaping (_ listCards: [CCCard]) -> Void, onError: @escaping (_ error: NSError) -> Void) {
    cardService.getAvailableCards(completion: { (jsonCards) in
      let cards: [CCCard] = Mapper().mapArray(JSONArray: jsonCards)!//.mapArray(jsonCards)!
      completion(cards)
    }) { (error) in
      onError(error)
    }
  }
  
  func getAvailableCardsFromBank(bank: CCBank, user: CCUser, completion: @escaping (_ listCards: [CCCard]) -> Void, onError: @escaping (_ error: NSError) -> Void) {
    cardService.getAvailableCardsFromBank(bank: bank,
      completion: { (jsonCards) in
        let cards: [CCCard] = Mapper().mapArray(JSONArray: jsonCards)!//.mapArray(jsonCards)!
        
        let cardsNoSelectedByUser = cards.filter({ (card) -> Bool in
          for profileCard in user.profileCards{
            if profileCard.card?.cardId == card.cardId{
              return false
            }
          }
          
          return true
        })
        
        completion(cardsNoSelectedByUser)
      },
      onError: { (error) in
        onError(error)
      }
    )
  }
  
  func saveCard(card: CCProfileCard, user: CCUser, completion: ((_ sucess: String)-> Void)?, onError: @escaping (_ error: NSError)->Void) {
    cardService.saveCard(card: card, user: user, completion: { (sucess) in
        completion?(sucess)
      }) { (error) in
        onError(error)
    }
  }
  
  func deleteCard(card: CCProfileCard, user: CCUser, completion: ((_ success: String)-> Void)?, onError: @escaping (_ error: NSError)->Void) {
    cardService.deleteCard(card: card, user: user, completion: { (sucess) in
      completion?(sucess)
    }) { (error) in
      onError(error)
    }
  }
  
  func getProfileCardsFromUser(user: CCUser, completion: @escaping (_ listCards: [CCProfileCard]) -> Void, onError: @escaping (_ error: NSError) -> Void) {
    cardService.getProfileCardsFromUser(user: user,
      completion: { (jsonCards) in
        let cards: [CCProfileCard] = Mapper().mapArray(JSONArray: jsonCards)!//.mapArray(jsonCards)!
        completion(cards)
      },
      onError: { (error) in
        onError(error)
      }
    )
  }

}
