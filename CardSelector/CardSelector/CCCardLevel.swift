//
//  CardLevel.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCCardLevel: Mappable {
  var cardLevelId = 0
  var name = ""
  var description = ""

  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    cardLevelId   <- map["Id"]
    name            <- map["Name"]
    description     <- map["Description"]
  }
}
