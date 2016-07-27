//
//  CCCard.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCCard: NSObject, Mappable, NSCoding {
  var cardId = 0
  var code = ""
  var defaultRate: Double = 0.0
  var bank: CCBank?
  var cardType: CCCardType?
  var cardProgram: CCCardProgram?
  var cardLevel: CCCardLevel?
  var color = UIColor.whiteColor()
  var selected = false
  
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    cardId        <- map["Id"]
    code          <- map["Code"]
    defaultRate   <- map["DefaultRate"]
    bank          <- map["Bank"]
    cardType      <- map["CardType"]
    cardProgram   <- map["CardProgram"]
    cardLevel     <- map["Level"]
  }
  
  
  
  init(cardDictionary: [String: AnyObject]) {
    self.cardId     = cardDictionary["cardId"] as! Int
    self.code     = cardDictionary["code"] as! String
    self.defaultRate = cardDictionary["defaultRate"] as! Double
    
    self.bank = cardDictionary["bank"] as? CCBank
    self.cardType = cardDictionary["cardType"] as? CCCardType
    self.cardProgram = cardDictionary["cardProgram"] as? CCCardProgram
    self.cardLevel = cardDictionary["cardLevel"] as? CCCardLevel
    
    self.color = cardDictionary["color"] as! UIColor
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let cardId      = decoder.decodeObjectForKey("cardId") as? Int,
      let code      = decoder.decodeObjectForKey("code") as? String,
      let defaultRate  = decoder.decodeObjectForKey("defaultRate") as? Double,
      
      let bank  = decoder.decodeObjectForKey("bank") as? CCBank,
      let cardType  = decoder.decodeObjectForKey("cardType") as? CCCardType,
      let cardProgram  = decoder.decodeObjectForKey("cardProgram") as? CCCardProgram,
      let cardLevel  = decoder.decodeObjectForKey("cardLevel") as? CCCardLevel,
      let color  = decoder.decodeObjectForKey("color") as? UIColor
    
      else{ return nil }
    
    let dictionary: [String: AnyObject] = [
      "cardId"      : cardId,
      "code"      : code,
      "defaultRate"  : defaultRate,
      "bank": bank,
      "cardType": cardType,
      "cardProgram": cardProgram,
      "cardLevel": cardLevel,
      "color": color
    ]
    
    self.init(cardDictionary: dictionary )
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.cardId,   forKey: "cardId")
    coder.encodeObject(self.code,   forKey: "code")
    coder.encodeObject(self.defaultRate, forKey: "defaultRate")
    
    coder.encodeObject(self.bank, forKey: "bank")
    coder.encodeObject(self.cardType, forKey: "cardType")
    coder.encodeObject(self.cardProgram, forKey: "cardProgram")
    coder.encodeObject(self.cardLevel, forKey: "cardLevel")
    coder.encodeObject(self.color, forKey: "color")
  }
}
