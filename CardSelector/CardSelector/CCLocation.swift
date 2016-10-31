//
//  CCLocation.swift
//  Card Compadre
//
//  Created by projas on 7/31/16.
//  Copyright © 2016 mbt. All rights reserved.
//

import UIKit
import ObjectMapper

class CCLocation: Mappable {
  var latitude: Double?
  var longitude: Double?
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    latitude            <- map["geometry.location.lat"]
    longitude          <- map["geometry.location.lng"]
  }
}
