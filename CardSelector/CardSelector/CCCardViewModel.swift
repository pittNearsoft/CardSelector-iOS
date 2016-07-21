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
  
  func getAvailableCards(completion: (listCards: [CCCard]) -> Void, onError: (error: NSError) -> Void) {
    cardService.getAvailableCards({ (jsonCards) in
      let cards: [CCCard] = Mapper<CCCard>().mapArray(jsonCards)!
      completion(listCards: cards)
    }) { (error) in
      onError(error: error)
    }
  }
  
  func getAvailableCardsFromBank(bank: CCBank,completion: (listCards: [CCCard]) -> Void, onError: (error: NSError) -> Void) {    
    cardService.getAvailableCardsFromBank(bank,
      completion: { (jsonCards) in
        let cards: [CCCard] = Mapper<CCCard>().mapArray(jsonCards)!
        completion(listCards: cards)
      },
      onError: { (error) in
        onError(error: error)
      }
    )
  }
  
  func saveCard(card: CCProfileCard, user: CCUser, completion: ((sucess: String)-> Void)?, onError: (error: NSError)->Void) {
    cardService.saveCard(card, user: user, completion: { (sucess) in
        completion?(sucess: sucess)
      }) { (error) in
        onError(error: error)
    }
  }
  
  func getProfileCardsFromUser(user: CCUser, completion: (listCards: [CCProfileCard]) -> Void, onError: (error: NSError) -> Void) {
    cardService.getProfileCardsFromUser(user,
      completion: { (jsonCards) in
        let cards: [CCProfileCard] = Mapper<CCProfileCard>().mapArray(jsonCards)!
        completion(listCards: cards)
      },
      onError: { (error) in
        onError(error: error)
      }
    )
  }

}
