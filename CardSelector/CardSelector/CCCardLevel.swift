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

  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    cardLevelId   <- map["Id"]
    name          <- map["Name"]
    levelDescription   <- map["Description"]
    isEnabled     <- map["IsEnabled"]
  }
  
  init(levelDictionary: [String: AnyObject]) {
    self.cardLevelId     = levelDictionary["cardLevelId"] as! Int
    self.name     = levelDictionary["name"] as! String
    self.levelDescription = levelDictionary["description"] as! String
    self.isEnabled = levelDictionary["isEnabled"] as! Bool
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let cardLevelId      = decoder.decodeObjectForKey("cardLevelId") as? Int,
      let name      = decoder.decodeObjectForKey("name") as? String,
      let description  = decoder.decodeObjectForKey("description") as? String,
      let isEnabled = decoder.decodeObjectForKey("isEnabled") as? Bool
      
      else{ return nil }
    
    let dictionary: [String : AnyObject]  = [
      "cardLevelId"      : cardLevelId,
      "name"      : name,
      "description"  : description,
      "isEnabled": isEnabled
    ]
    
    self.init(levelDictionary: dictionary )
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.cardLevelId,   forKey: "cardLevelId")
    coder.encodeObject(self.name,   forKey: "name")
    coder.encodeObject(self.levelDescription, forKey: "description")
    coder.encodeObject(self.isEnabled, forKey: "isEnabled")
    
  }
}
