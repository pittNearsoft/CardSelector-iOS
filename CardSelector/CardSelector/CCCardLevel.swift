//
//  CardLevel.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCCardLevel: NSObject, NSCoding, Mappable {
  var cardLevelId = 0
  var name = ""
  var levelDescription = ""
  var isEnabled = false

  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    cardLevelId   <- map["Id"]
    name          <- map["Name"]
    levelDescription   <- map["Description"]
    isEnabled     <- map["IsEnabled"]
  }
  
  init(levelDictionary: [String: Any]) {
    self.cardLevelId     = levelDictionary["cardLevelId"] as! Int
    self.name     = levelDictionary["name"] as! String
    self.levelDescription = levelDictionary["description"] as! String
    self.isEnabled = levelDictionary["isEnabled"] as! Bool
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let cardLevelId      = decoder.decodeObject(forKey: "cardLevelId") as? Int,
      let name      = decoder.decodeObject(forKey: "name") as? String,
      let description  = decoder.decodeObject(forKey: "description") as? String,
      let isEnabled = decoder.decodeObject(forKey: "isEnabled") as? Bool
      
      else{ return nil }
    
    let dictionary: [String : Any]  = [
      "cardLevelId"      : cardLevelId,
      "name"      : name,
      "description"  : description,
      "isEnabled": isEnabled
    ]
    
    self.init(levelDictionary: dictionary )
  }

  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.cardLevelId,   forKey: "cardLevelId")
    aCoder.encode(self.name,   forKey: "name")
    aCoder.encode(self.levelDescription, forKey: "description")
    aCoder.encode(self.isEnabled, forKey: "isEnabled")
  }
}
