//
//  CCCardProgram.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCCardProgram: NSObject, NSCoding, Mappable {
  var cardProgramId = 0
  var name = ""
  var programDescription = ""
  
  
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    cardProgramId   <- map["Id"]
    name            <- map["Name"]
    programDescription     <- map["Description"]
  }
  
  init(programDictionary: [String: AnyObject]) {
    self.cardProgramId     = programDictionary["cardProgramId"] as! Int
    self.name     = programDictionary["name"] as! String
    self.programDescription = programDictionary["description"] as! String
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let cardProgramId      = decoder.decodeObjectForKey("cardProgramId") as? Int,
      let name      = decoder.decodeObjectForKey("name") as? String,
      let description  = decoder.decodeObjectForKey("description") as? String
      
      else{ return nil }
    
    let dictionary: [String : AnyObject]  = [
      "cardProgramId"      : cardProgramId,
      "name"      : name,
      "description"  : description
    ]
    
    self.init(programDictionary: dictionary )
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.cardProgramId,   forKey: "cardProgramId")
    coder.encodeObject(self.name,   forKey: "name")
    coder.encodeObject(self.programDescription, forKey: "description")
    
  }
}
