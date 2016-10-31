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
  
  func getAvailableBanks(completion: @escaping (_ listBanks: [CCBank]) -> Void, onError: @escaping (_ error: NSError) -> Void) {
    bankService.getAvailableBanks(completion: { (jsonBanks) in
      let banks: [CCBank] = Mapper().mapArray(JSONArray: jsonBanks)!//.mapArray(jsonBanks)!
      completion(banks)
    }) { (error) in
      onError(error)
    }
  }
  
}
