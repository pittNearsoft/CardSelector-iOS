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
  
  func asURLRequest() throws -> URLRequest {
    let url = APIClient.getFullGoogleUrlWithPath(path: path)
    var urlRequest = URLRequest(url: url!)
    
    urlRequest.httpMethod = method.rawValue
    
    return urlRequest
  }
  
  case fetchNearbyPlacesWithCoordinate(coodinate: CLLocationCoordinate2D, radius: Double, types: [String])
  case fetchPlacePhotoFromReference(reference: String)
  case getGeocodeByPlaceId(placeId: String)
  
  var method: HTTPMethod{
    switch self {
    case .fetchNearbyPlacesWithCoordinate, .fetchPlacePhotoFromReference, .getGeocodeByPlaceId:
      return .get
    }
  }
  
  var path: String{
    switch self {
    case .fetchNearbyPlacesWithCoordinate(let coordinate, let radius, let types):
      let typesString = types.joined(separator: "|")
      return "place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&types=\(typesString)"
      
    case .fetchPlacePhotoFromReference(let reference):
      return "place/photo?maxwidth=200&photoreference=\(reference)"
      
    case .getGeocodeByPlaceId(let placeId):
      return "place/details/json?placeid=\(placeId)"

    }
    
    
  }
  

}
