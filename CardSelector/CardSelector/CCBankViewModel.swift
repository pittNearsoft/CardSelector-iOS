//
//  CCBankViewModel.swift
//  CardSelector
//
//  Created by projas on 7/19/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCBankViewModel {
  let bankService = CCBankService()
  
  func getAvailableBanks(completion: (listBanks: [CCBank]) -> Void, onError: (error: NSError) -> Void) {
    bankService.getAvailableBanks({ (jsonBanks) in
      let banks: [CCBank] = Mapper<CCBank>().mapArray(jsonBanks)!
      completion(listBanks: banks)
    }) { (error) in
      onError(error: error)
    }
  }
  
}
