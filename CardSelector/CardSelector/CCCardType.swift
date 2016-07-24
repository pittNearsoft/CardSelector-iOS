//
//  CCCardType.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//


import Foundation
import ObjectMapper

class CCCardType: NSObject, NSCoding, Mappable {
  var typeId = 0
  var name = ""
  var typeDescription = ""
  
  
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    typeId      <- map["Id"]
    name        <- map["Name"]
    typeDescription <- map["Description"]
  }
  
  
  init(typeDictionary: [String: AnyObject]) {
    self.typeId     = typeDictionary["typeId"] as! Int
    self.name     = typeDictionary["name"] as! String
    self.typeDescription = typeDictionary["description"] as! String
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let typeId      = decoder.decodeObjectForKey("typeId") as? Int,
      let name      = decoder.decodeObjectForKey("name") as? String,
      let description  = decoder.decodeObjectForKey("description") as? String
      
      else{ return nil }
    
    let dictionary: [String : AnyObject]  = [
      "typeId"      : typeId,
      "name"      : name,
      "description"  : description
    ]
    
    self.init(typeDictionary: dictionary )
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.typeId,   forKey: "typeId")
    coder.encodeObject(self.name,   forKey: "name")
    coder.encodeObject(self.typeDescription, forKey: "description")
    
  }
}
