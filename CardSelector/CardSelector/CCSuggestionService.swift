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
  
  func getSuggestions(user: CCUser, merchant: String, completion: (jsonSuggestions: [AnyObject])-> Void, onError: (error: NSError)->Void) {
    apiClient.manager.request(CCSuggestionRouter.getSuggestions(user: user, merchant: merchant))
      .CCresponseJSON { (response) in
        
        switch response.result{
        case .Success(let JSON):
          
          if let message = JSON["Message"] as? String{
            
            if message == "No Data" {
              completion(jsonSuggestions: [])
              return
            }
            
          }
          
          guard let result = JSON as? [AnyObject] else{
            onError(error: Error.error(code: -1, failureReason: "Bad json received"))
            return
          }
          completion(jsonSuggestions: result)
          
        case .Failure(let error):
          onError(error: error)
        }
        
    }
  }
  
}