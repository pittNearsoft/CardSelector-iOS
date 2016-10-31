//
//  CCPlaceService.swift
//  CardSelector
//
//  Created by projas on 7/7/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire
import CoreLocation

class CCPlaceService {
  private let apiClient = APIClient()
  
  func fetchNearbyPlacesWithCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types: [String], completion: @escaping (_ jsonPlaces: [[String: AnyObject]]) -> Void, onError: @escaping (_ error: NSError)->Void) {
    
    apiClient.manager.request(CCPlaceRouter.fetchNearbyPlacesWithCoordinate(coodinate: coordinate, radius: radius, types: types))
      .responseJSON { (response) in
        switch response.result{
          case .success(let JSON):
            let jsonObject = JSON as AnyObject
            
            guard let result = jsonObject["results"] as? [[String: AnyObject]] else{
              onError(NSError(domain: "com.kompi", code: -1, userInfo: ["reason": "Bad json received"]))
              return
            }
            completion(result)
          
          case .failure(let error):
            onError(error as NSError)
          
        }
    }
    
  }
  
  func getGeocodeByPlaceId(placeId: String, completion: @escaping (_ json: [String: AnyObject]) -> Void, onFailure: @escaping (_ error: NSError)-> Void ) {
    
    apiClient.manager.request(CCPlaceRouter.getGeocodeByPlaceId(placeId: placeId))
      .responseJSON { response in
        
        switch response.result{
        case .success(let JSON):
          
           let jsonObject = JSON as AnyObject
          
          guard let result = jsonObject["result"] as? [String: AnyObject]
            else{
              onFailure(NSError(domain: "com.kompi", code: -1, userInfo: ["reason": "Bad json received"]))
              return
          }
          completion(result)
        case .failure(let error):
          onFailure(error as NSError)
          
        }
        
    }
  }
}
