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

  func transformFromJSON(_ value: Any?) -> CLLocationCoordinate2D? {
    guard let coordinate = value as? [String: Double] else { return nil}
    
    return CLLocationCoordinate2D(latitude: coordinate["lat"]!, longitude: coordinate["lng"]!)
  }
  
  func transformToJSON(_ value: CLLocationCoordinate2D?) -> Dictionary<String, Double>? {
    if let coordinate = value {
      return [
        "lat": coordinate.latitude,
        "lng": coordinate.longitude
      ]
    }
    
    return nil
  }

}
