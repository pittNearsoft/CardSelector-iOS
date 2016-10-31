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
  
  
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    typeId      <- map["Id"]
    name        <- map["Name"]
    typeDescription <- map["Description"]
  }
  
  
  init(typeDictionary: [String: Any]) {
    self.typeId     = typeDictionary["typeId"] as! Int
    self.name     = typeDictionary["name"] as! String
    self.typeDescription = typeDictionary["description"] as! String
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let typeId      = decoder.decodeObject(forKey: "typeId") as? Int,
      let name      = decoder.decodeObject(forKey: "name") as? String,
      let description  = decoder.decodeObject(forKey: "description") as? String
      
      else{ return nil }
    
    let dictionary: [String : Any]  = [
      "typeId"      : typeId,
      "name"      : name,
      "description"  : description
    ]
    
    self.init(typeDictionary: dictionary )
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.typeId,   forKey: "typeId")
    aCoder.encode(self.name,   forKey: "name")
    aCoder.encode(self.typeDescription, forKey: "description")
  }
}
