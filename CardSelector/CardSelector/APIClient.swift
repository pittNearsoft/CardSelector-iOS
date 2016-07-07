//
//  APIClient.swift
//  CardSelector
//
//  Created by projas on 7/7/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import Alamofire

class APIClient {
  private static let googlePlacesBaseUrl = "https://maps.googleapis.com/maps/api/"
  private static let googlePlacesApiKey = "AIzaSyCTMaGzeNwKSEZOkPqtMo3mqpcJfnoj48w"
  
  var manager: Manager!
  
  init(){
    let configuration  = NSURLSessionConfiguration.defaultSessionConfiguration()
    manager = Alamofire.Manager(configuration: configuration)
  }
  
  static func getFullUrlWithPath(path: String) -> NSURL{
    return NSURL(string: googlePlacesBaseUrl+path+"&key=\(googlePlacesApiKey)")!
  }
  
}
