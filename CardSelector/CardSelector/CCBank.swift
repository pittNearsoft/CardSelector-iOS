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
  
  required init?(_ map: Map) {
    
  }
  
  init(bankId: Int, name: String, description: String){
    self.bankId = bankId
    self.name = name
    self.bankDescription = description
  }
  
  
  init(bankDictionary: [String: AnyObject]) {
    self.bankId     = bankDictionary["bankId"] as! Int
    self.name     = bankDictionary["name"] as! String
    self.bankDescription = bankDictionary["description"] as! String
  }
  
  
  convenience required init?(coder decoder: NSCoder) {
    guard let bankId      = decoder.decodeObjectForKey("bankId") as? Int,
      let name      = decoder.decodeObjectForKey("name") as? String,
      let description  = decoder.decodeObjectForKey("description") as? String
      
      else{ return nil }
    
    let dictionary: [String : AnyObject]  = [
      "bankId"      : bankId,
      "name"      : name,
      "description"  : description
    ]
    
    self.init(bankDictionary: dictionary)
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.bankId,   forKey: "bankId")
    coder.encodeObject(self.name,   forKey: "name")
    coder.encodeObject(self.description, forKey: "description")
    
  }
}

extension CCBank: Mappable{
  func mapping(map: Map) {
    bankId      <- map["Id"]
    name        <- map["Name"]
    bankDescription <- map["Description"]
  }
}

