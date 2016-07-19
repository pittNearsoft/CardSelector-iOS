//
//  CCBankService.swift
//  CardSelector
//
//  Created by projas on 7/19/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

class CCBankService {
  private let apiClient = APIClient()
  
  func getAvailableBanks(completion: (jsonCards: [AnyObject])-> Void, onError: (error: NSError)->Void) {
    apiClient.manager.request(CCBankRouter.getAvailableBanks())
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

  
}
