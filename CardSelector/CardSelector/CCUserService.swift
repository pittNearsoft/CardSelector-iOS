//
//  CCUserService.swift
//  CardSelector
//
//  Created by projas on 7/22/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

class CCUserService {
  private let apiClient = APIClient()

  func getUserProfileWithEmail(email: String, completion: (jsonProfile: [String: AnyObject]?)-> Void, onError: (error: NSError)->Void ) {
    apiClient.manager.request(CCUserRouter.getUserFromServerWithEmail(email: email))
      .CCresponseJSON { (response) in
        
        switch response.result{
        case .Success(let JSON):
          
          if let message = JSON["Message"] as? String{
            
            if message == "No Data" {
              completion(jsonProfile: nil)
              return
            }
            
          }
          
          guard let result = JSON as? [String: AnyObject] else{
            onError(error: Error.error(code: -1, failureReason: "Bad json received"))
            return
          }
          completion(jsonProfile: result)
          
        case .Failure(let error):
          onError(error: error)
        }
        
    }
  }
  
  func saveUserIntoServer(user: CCUser, completion: (jsonProfile: [String: AnyObject])-> Void, onError: (error: NSError)->Void) {
    apiClient.manager.request(CCUserRouter.saveUserIntoServer(user: user))
      .CCresponseJSON { (response) in
      
        switch response.result{
        case .Success(let JSON):
          
          guard let result = JSON as? [String: AnyObject] else{
            onError(error: Error.error(code: -1, failureReason: "Bad json received"))
            return
          }
          completion(jsonProfile: result)
          
        case .Failure(let error):
          onError(error: error)
        }
        
    }
  }
  
}
