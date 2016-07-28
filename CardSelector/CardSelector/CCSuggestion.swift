//
//  CCSuggestion.swift
//  CardSelector
//
//  Created by projas on 7/28/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper


class CCSuggestion: Mappable {
  var bankId = ""
  var bankName = ""
  var message = "No data found"
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    bankId        <- map["BankId"]
    bankName        <- map["BankName"]
    message        <- map["Message"]
  }
  
  init(){}
  
  
}
