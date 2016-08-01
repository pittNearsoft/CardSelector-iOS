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
  case fetchNearbyPlacesWithCoordinate(coodinate: CLLocationCoordinate2D, radius: Double, types: [String])
  case fetchPlacePhotoFromReference(reference: String)
  case getGeocodeByPlaceId(placeId: String)
  
  var method: Alamofire.Method{
    switch self {
    case .fetchNearbyPlacesWithCoordinate, .fetchPlacePhotoFromReference, .getGeocodeByPlaceId:
      return .GET
    }
  }
  
  var path: String{
    switch self {
    case .fetchNearbyPlacesWithCoordinate(let coordinate, let radius, let types):
      let typesString = types.joinWithSeparator("|")
      return "place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&types=\(typesString)"
      
    case .fetchPlacePhotoFromReference(let reference):
      return "place/photo?maxwidth=200&photoreference=\(reference)"
      
    case .getGeocodeByPlaceId(let placeId):
      return "place/details/json?placeid=\(placeId)"

    }
    
    
  }
  
  var URLRequest: NSMutableURLRequest{
    let url = APIClient.getFullGoogleUrlWithPath(path)
    let mutableURLRequest = NSMutableURLRequest(URL: url!)
    
    mutableURLRequest.HTTPMethod = method.rawValue
    
    return mutableURLRequest
  }

}
