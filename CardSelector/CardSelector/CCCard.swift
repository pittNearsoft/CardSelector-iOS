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
  var color = UIColor.white
  var selected = false
  
  
  required init?(map: Map) {
    
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
  
  
  
  init(cardDictionary: [String: Any]) {
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
    guard let cardId      = decoder.decodeObject(forKey: "cardId") as? Int,
      let code      = decoder.decodeObject(forKey: "code") as? String,
      let defaultRate  = decoder.decodeObject(forKey: "defaultRate") as? Double,
      
      let bank  = decoder.decodeObject(forKey: "bank") as? CCBank,
      let cardType  = decoder.decodeObject(forKey: "cardType") as? CCCardType,
      let cardProgram  = decoder.decodeObject(forKey: "cardProgram") as? CCCardProgram,
      let cardLevel  = decoder.decodeObject(forKey: "cardLevel") as? CCCardLevel,
      let color  = decoder.decodeObject(forKey: "color") as? UIColor
    
      else{ return nil }
    
    let dictionary: [String: Any] = [
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
  

  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.cardId,   forKey: "cardId")
    aCoder.encode(self.code,   forKey: "code")
    aCoder.encode(self.defaultRate, forKey: "defaultRate")
    
    aCoder.encode(self.bank, forKey: "bank")
    aCoder.encode(self.cardType, forKey: "cardType")
    aCoder.encode(self.cardProgram, forKey: "cardProgram")
    aCoder.encode(self.cardLevel, forKey: "cardLevel")
    aCoder.encode(self.color, forKey: "color")
  }
}
