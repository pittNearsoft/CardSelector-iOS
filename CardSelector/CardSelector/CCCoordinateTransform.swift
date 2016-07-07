//
//  CCCoordinateTransform.swift
//  CardSelector
//
//  Created by projas on 7/6/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class CCCoordinateTransform: TransformType {

  func transformFromJSON(value: AnyObject?) -> CLLocationCoordinate2D? {
    
    guard let coordinate = value as? [String: Double] else { return nil}
    
    return CLLocationCoordinate2D(latitude: coordinate["lat"]!, longitude: coordinate["lng"]!)
  }
  
  func transformToJSON(value: CLLocationCoordinate2D?) -> [String: Double]?{
    if let coordinate = value {
      return [
        "lat": coordinate.latitude,
        "lng": coordinate.longitude
      ]
    }
    
    return nil
  }

}
