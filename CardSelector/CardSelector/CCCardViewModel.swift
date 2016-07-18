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
  
  func getAvailableCards(completion: (listCards: [CCCard])-> Void, onError: (error: NSError)->Void) {
    cardService.getAvailableCards({ (jsonCards) in
      let cards: [CCCard] = Mapper<CCCard>().mapArray(jsonCards)!
      completion(listCards: cards)
    }) { (error) in
      onError(error: error)
    }
  }

}
