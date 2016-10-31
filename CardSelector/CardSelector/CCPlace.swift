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
import GoogleMaps
import GooglePlaces


class CCPlace: Mappable {
  var name = ""
  var address = ""
  var coordinate = CLLocationCoordinate2D()
  var placeType = ""
  var photo_reference = ""
  var photo = UIImage(named: "generic")
  var id = ""
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    name        <- map["name"]
    address     <- map["vicinity"]
    coordinate  <- (map["geometry.location"], CCCoordinateTransform())
    placeType   <- (map["types"],CCPlaceTypeTransform())
    photo_reference    <- map["photos.0.photo_reference"]
  }
  
  init(WithPrediction prediction: GMSAutocompletePrediction) {
    self.address = prediction.attributedFullText.string
    self.name = prediction.attributedPrimaryText.string
    self.id = prediction.placeID!
  }
  
}

