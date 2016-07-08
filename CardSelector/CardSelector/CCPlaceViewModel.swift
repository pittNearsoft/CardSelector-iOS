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
  
  func fetchNearbyPlacesWithCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types: [String], completion: (places: [CCPlace])->Void, onError: (error: NSError) -> Void) {
    
    placeService.fetchNearbyPlacesWithCoordinate(coordinate, radius: radius, types: types,
      completion: { (jsonPlaces) in
        let places: [CCPlace] = Mapper<CCPlace>().mapArray(jsonPlaces)!
        completion(places: places)
      },
      onError: { (error) in
        onError(error: error)
      }
    )
  }
}
