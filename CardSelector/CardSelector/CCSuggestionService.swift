//
//  CCSuggestionService.swift
//  CardSelector
//
//  Created by projas on 7/23/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

class CCSuggestionService {
  private let apiClient = APIClient()
  
  func getSuggestionsWithUser(user: CCUser, merchant: CCPlace, completion: @escaping (_ jsonSuggestions: [[String: AnyObject]])-> Void, onError: @escaping (_ error: NSError)->Void) {
    apiClient.manager.request(CCSuggestionRouter.getSuggestionsWithUser(user: user, merchant: merchant))
      .responseJSON { (response) in
        
        switch response.result{
        case .success(let JSON as AnyObject):
          
          if let message = JSON["Message"] as? String{
            
            if message == "No Data" {
              completion([])
              return
            }
            
          }
          
          guard let result = JSON as? [[String: AnyObject]] else{
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
