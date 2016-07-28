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

  required init?(_ map: Map) {
    
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
  
  
  
  init(profileCardDictionary: [String: AnyObject]) {
    self.card         = profileCardDictionary["card"] as? CCCard
    self.endingCard   = profileCardDictionary["endingCard"] as! Int
    self.interestRate = profileCardDictionary["interestRate"] as! Double
    self.cuttOffDay   = profileCardDictionary["cuttOffDay"] as! Int
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let card      = decoder.decodeObjectForKey("card") as? CCCard,
      let endingCard    = decoder.decodeObjectForKey("endingCard") as? Int,
      let interestRate  = decoder.decodeObjectForKey("interestRate") as? Double,
      let cuttOffDay    = decoder.decodeObjectForKey("cuttOffDay") as? Int
      else{ return nil }
    
    let dictionary: [String: AnyObject] = [
      "card"          : card,
      "endingCard"    : endingCard,
      "interestRate"  : interestRate,
      "cuttOffDay"    : cuttOffDay
    ]
    
    self.init(profileCardDictionary: dictionary)
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.card,   forKey: "card")
    coder.encodeObject(self.endingCard,   forKey: "endingCard")
    coder.encodeObject(self.interestRate, forKey: "interestRate")
    coder.encodeObject(self.cuttOffDay, forKey: "cuttOffDay")
  }
  
  
  
}
