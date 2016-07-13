//
//  CCCardType.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//


import Foundation
import ObjectMapper

class CCCardType: Mappable {
  var typeId = 0
  var name = ""
  var description = ""
  
  
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    typeId      <- map["Id"]
    name        <- map["Name"]
    description <- map["Description"]
  }
}
