//
//  CCBank.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCBank: Mappable {
  var bankId = 0
  var name = ""
  var description = ""
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    bankId      <- map["Id"]
    name        <- map["Name"]
    description <- map["Description"]
  }
  
  init(bankId: Int, name: String, description: String){
    self.bankId = bankId
    self.name = name
    self.description = description
  }
  
}
