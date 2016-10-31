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
  
  func getAvailableBanks(completion: @escaping (_ jsonBanks: [[String: AnyObject]])-> Void, onError: @escaping (_ error: NSError)->Void) {
    apiClient.manager.request(CCBankRouter.getAvailableBanks())
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

  
}
