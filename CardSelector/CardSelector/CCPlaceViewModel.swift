//
//  CCPlaceViewModel.swift
//  CardSelector
//
//  Created by projas on 7/7/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

class CCPlaceViewModel {
  let placeService = CCPlaceService()
  
  func fetchNearbyPlacesWithCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types: [String], completion: @escaping (_ places: [CCPlace])->Void, onError: @escaping (_ error: NSError) -> Void) {
    
    placeService.fetchNearbyPlacesWithCoordinate(coordinate: coordinate, radius: radius, types: types,
      completion: { (jsonPlaces) in
        let places: [CCPlace] = Mapper<CCPlace>().mapArray(JSONArray: jsonPlaces)!//.mapArray(jsonPlaces)!
        completion(places)
      },
      onError: { (error) in
        onError(error)
      }
    )
  }
  
  func getGeocodeByPlaceId(placeId: String, completion: @escaping (_ coordinate: CLLocationCoordinate2D) -> Void, onFailure: @escaping (_ error: NSError)-> Void ) {
    
    placeService.getGeocodeByPlaceId(placeId: placeId, completion: { (json) in
      let location = Mapper<CCLocation>().map(JSON: json)//.map(json)
      
      completion(CLLocationCoordinate2DMake((location?.latitude)!, (location?.longitude)!))
    }) { (error) in
      onFailure(error)
    }
  }
}
