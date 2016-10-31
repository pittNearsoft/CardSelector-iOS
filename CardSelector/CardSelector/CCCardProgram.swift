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
  
  
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    cardProgramId   <- map["Id"]
    name            <- map["Name"]
    programDescription     <- map["Description"]
  }
  
  init(programDictionary: [String: Any]) {
    self.cardProgramId     = programDictionary["cardProgramId"] as! Int
    self.name     = programDictionary["name"] as! String
    self.programDescription = programDictionary["description"] as! String
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let cardProgramId      = decoder.decodeObject(forKey: "cardProgramId") as? Int,
      let name      = decoder.decodeObject(forKey: "name") as? String,
      let description  = decoder.decodeObject(forKey: "description") as? String
      
      else{ return nil }
    
    let dictionary: [String : Any]  = [
      "cardProgramId"      : cardProgramId,
      "name"      : name,
      "description"  : description
    ]
    
    self.init(programDictionary: dictionary )
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.cardProgramId,   forKey: "cardProgramId")
    aCoder.encode(self.name,   forKey: "name")
    aCoder.encode(self.programDescription, forKey: "description")
  }
}
