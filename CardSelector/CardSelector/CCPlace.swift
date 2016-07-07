//
//  CCPlace.swift
//  CardSelector
//
//  Created by projas on 7/6/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper


class CCPlace: Mappable {
  var name = ""
  var address = ""
  var coordinate = CLLocationCoordinate2D()
  var placeType = ""
  var photo_reference = ""
  var photo = UIImage(named: "generic")
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    name        <- map["name"]
    address     <- map["vicinity"]
    coordinate  <- (map["geometry.location"], CCCoordinateTransform())
    placeType   <- (map["types"],CCPlaceTypeTransform())
    photo_reference    <- map["photos.0.photo_reference"]
  }
  
}

