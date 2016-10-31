//
//  CCProfileCard.swift
//  CardSelector
//
//  Created by projas on 7/20/16.
//  Copyright © 2016 ABC. All rights reserved.
//


import Foundation
import ObjectMapper

class CCProfileCard: NSObject, Mappable, NSCoding {
  
  var card: CCCard?
  var endingCard = -1
  var interestRate: Double = -1
  var cuttOffDay = -1

  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    card          <- map["Card"]
    endingCard    <- map["EndingCard"]
    interestRate  <- map["InterestRate"]
    cuttOffDay    <- map["CuttOffDay"]
  }
  
  override init(){
    super.init()
  }
  
  
  
  init(profileCardDictionary: [String: Any]) {
    self.card         = profileCardDictionary["card"] as? CCCard
    self.endingCard   = profileCardDictionary["endingCard"] as! Int
    self.interestRate = profileCardDictionary["interestRate"] as! Double
    self.cuttOffDay   = profileCardDictionary["cuttOffDay"] as! Int
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let card      = decoder.decodeObject(forKey: "card") as? CCCard,
      let endingCard    = decoder.decodeObject(forKey: "endingCard") as? Int,
      let interestRate  = decoder.decodeObject(forKey: "interestRate") as? Double,
      let cuttOffDay    = decoder.decodeObject(forKey: "cuttOffDay") as? Int
      else{ return nil }
    
    let dictionary: [String: Any] = [
      "card"          : card,
      "endingCard"    : endingCard,
      "interestRate"  : interestRate,
      "cuttOffDay"    : cuttOffDay
    ]
    
    self.init(profileCardDictionary: dictionary)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.card,   forKey: "card")
    aCoder.encode(self.endingCard,   forKey: "endingCard")
    aCoder.encode(self.interestRate, forKey: "interestRate")
    aCoder.encode(self.cuttOffDay, forKey: "cuttOffDay")
  }
  
  
  
}
