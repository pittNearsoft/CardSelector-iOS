//
//  CCPlaceRouter.swift
//  CardSelector
//
//  Created by projas on 7/7/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire
import CoreLocation

enum CCPlaceRouter: URLRequestConvertible {
  case fetchNearbyPlacesWithCoordinate(coodinate: CLLocationCoordinate2D, radius: Double)
  
  var method: Alamofire.Method{
    switch self {
    case .fetchNearbyPlacesWithCoordinate:
      return .GET
    }
  }
  
  var path: String{
    switch self {
    case .fetchNearbyPlacesWithCoordinate(let coordinate, let radius):
      return "place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true"
    }
    
    
  }
  
  var URLRequest: NSMutableURLRequest{
    let url = APIClient.getFullUrlWithPath(path)
    let mutableURLRequest = NSMutableURLRequest(URL: url)
    
    mutableURLRequest.HTTPMethod = method.rawValue
    
    return mutableURLRequest
  }

}
