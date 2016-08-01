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
  
  func fetchNearbyPlacesWithCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types: [String], completion: (jsonPlaces: [AnyObject]) -> Void, onError: (error: NSError)->Void) {
    
    apiClient.manager.request(CCPlaceRouter.fetchNearbyPlacesWithCoordinate(coodinate: coordinate, radius: radius, types: types))
      .CCresponseJSON { (response) in
        switch response.result{
          case .Success(let JSON):
            guard let result = JSON["results"] as? [AnyObject] else{
              onError(error: Error.error(code: -1, failureReason: "Bad json received"))
              return
            }
            completion(jsonPlaces: result)
          
          case .Failure(let error):
            onError(error: error)
        }
    }
  }
  
  func getGeocodeByPlaceId(placeId: String, completion: (json: [String: AnyObject]) -> Void, onFailure: (error: NSError)-> Void ) {
    
    apiClient.manager.request(CCPlaceRouter.getGeocodeByPlaceId(placeId: placeId))
      .CCresponseJSON { response in
        
        switch response.result{
        case .Success(let JSON):
          
          guard let result = JSON["result"] as? [String: AnyObject]
            else{
              onFailure(error: Error.error(code: -1, failureReason: "Bad json received"))
              return
          }
          completion(json: result)
        case .Failure(let error):
          onFailure(error: error)
          
        }
        
    }
  }
}
