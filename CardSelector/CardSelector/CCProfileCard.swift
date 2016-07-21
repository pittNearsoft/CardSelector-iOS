//
//  CCProfileCard.swift
//  CardSelector
//
//  Created by projas on 7/20/16.
//  Copyright © 2016 ABC. All rights reserved.
//


import Foundation
import ObjectMapper

class CCProfileCard: Mappable {
  
  var card: CCCard?
  var endingCard = -1
  var interestRate: Double = -1

  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    card          <- map["Card"]
    endingCard    <- map["EndingCard"]
    interestRate  <- map["InterestRate"]
  }
  
  init(){
  
  }
}
