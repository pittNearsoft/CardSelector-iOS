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

  func getUserProfileWithEmail(email: String, completion: @escaping (_ jsonProfile: [String: Any]?)-> Void, onError: @escaping (_ error: NSError)->Void ) {
    apiClient.manager.request(CCUserRouter.getUserFromServerWithEmail(email: email))
      .responseJSON { (response) in
        
        switch response.result{
        case .success(let JSON as AnyObject):
          
          if let message = JSON["Message"] as? String{
            
            if message == "No Data" {
              completion(nil)
              return
            }
            
          }
          
          guard let result = JSON as? [String: Any] else{
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
  
  func saveUserIntoServer(user: CCUser, password: String = "" , completion: @escaping (_ jsonProfile: [String: Any])-> Void, onError: @escaping (_ error: NSError)->Void) {
    apiClient.manager.request(CCUserRouter.saveUserIntoServer(user: user, password: password))
      .responseJSON { (response) in
      
        switch response.result{
        case .success(let JSON):
          
          guard let result = JSON as? [String: Any] else{
            onError(NSError(domain: "com.kompi", code: -1, userInfo: ["reason": "Bad json received"]))
            return
          }
          completion(result)
          
        case .failure(let error):
          onError(error as NSError)
        

        }
        
    }
  }
  
  
  func authenticateUserWithEmail(email: String, password: String, completion: @escaping (_ jsonProfile: [String: Any]?)-> Void, onError: @escaping (_ error: NSError)->Void) {
    apiClient.manager.request(CCUserRouter.authenticateUserWithEmail(email: email, password: password))
      .responseJSON { (response) in
        switch response.result{
        case .success(let JSON as AnyObject):
          if let message = JSON["Message"] as? String{
            
            if message == "No Authenticated" {
              completion(nil)
              return
            }
            
          }
          
          
          guard let result = JSON as? [String: Any] else{
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
