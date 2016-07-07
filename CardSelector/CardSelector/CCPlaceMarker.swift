//
//  CCPlaceMarker.swift
//  CardSelector
//
//  Created by projas on 7/6/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import GoogleMaps

class CCPlaceMarker: GMSMarker {
  let place: CCPlace
  
  init(place: CCPlace){
    self.place = place
    super.init()
    
    position = place.coordinate
    icon = UIImage(named: place.placeType+"_pin")
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = kGMSMarkerAnimationPop
  }
}
