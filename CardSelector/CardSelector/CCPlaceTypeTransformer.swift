//
//  CCPlaceTypesTransformer.swift
//  CardSelector
//
//  Created by projas on 7/7/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCPlaceTypeTransform: TransformType {
  
  func transformFromJSON(value: AnyObject?) -> String? {
    guard let types = value as? [String] else { return nil}
    
    //Just a default value
    var foundType = "restaurant"
    
    //This validation must be done, because a place can be tagged by many types. Only is required one
    for type in types {
      if CCPlaceType.acceptedTypes.contains(type) {
        foundType = type
        break
      }
    }

    return foundType
  }
  
  func transformToJSON(value: String?) -> [String: String]? {
    
    if let type = value  {
      return ["type": type]
    }
    
    return nil
  }
}
