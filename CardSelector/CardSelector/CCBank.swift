//
//  CCBank.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Foundation
import ObjectMapper

class CCBank: NSObject, NSCoding {
  var bankId = 0
  var name = ""
  var bankDescription = ""
  
  var selected = false
  
  required init?(map: Map) {
    
  }
  
  init(bankId: Int, name: String, description: String){
    self.bankId = bankId
    self.name = name
    self.bankDescription = description
  }
  
  
  init(bankDictionary: [String: Any]) {
    self.bankId     = bankDictionary["bankId"] as! Int
    self.name     = bankDictionary["name"] as! String
    self.bankDescription = bankDictionary["description"] as! String
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let bankId      = decoder.decodeObject(forKey: "bankId") as? Int,
      let name      = decoder.decodeObject(forKey: "name") as? String,
      let description  = decoder.decodeObject(forKey: "description") as? String
      
      else{ return nil }
    
    let dictionary: [String : Any]  = [
      "bankId"      : bankId,
      "name"      : name,
      "description"  : description
    ]
    
    self.init(bankDictionary: dictionary)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.bankId,   forKey: "bankId")
    aCoder.encode(self.name,   forKey: "name")
    aCoder.encode(self.description, forKey: "description")
    
  }
}

extension CCBank: Mappable{
  func mapping(map: Map) {
    bankId      <- map["Id"]
    name        <- map["Name"]
    bankDescription <- map["Description"]
  }
}

