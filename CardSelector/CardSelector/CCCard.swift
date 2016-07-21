//
//  CCCard.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCCard: Mappable {
  var cardId = 0
  var code = ""
  var defaultRate: Double = 0.0
  var interestRate: Double = 0.0
  var bank: CCBank?
  var cardType: CCCardType?
  var cardProgram: CCCardProgram?
  var cardLevel: CCCardLevel?
  var color = UIColor.whiteColor()
  var ending = 0
  
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    cardId        <- map["Id"]
    code          <- map["Code"]
    defaultRate   <- map["DefaultRate"]
    interestRate  <- map["DefaultRate"]
    bank          <- map["Bank"]
    cardType      <- map["CardType"]
    cardProgram   <- map["CardProgram"]
    cardLevel     <- map["Level"]
  }
}
