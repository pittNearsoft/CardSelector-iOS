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
  private static let googlePlacesApiKey = "AIzaSyCy3sXYYV2-SOQioqZSrqgDlSv-p_mQtAE"
  private static let baseUrl = "http://www.muybuenotech.com/CC/Api/"
  
  var manager: Manager!
  
  init(){
    let configuration  = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    var addedHeaders = Manager.defaultHTTPHeaders
    addedHeaders["Authorization"] = "Basic QWRtaW46QzRyZEMwbXA0ZHIzOjVFOTA3ODRSRg=="
    
    configuration.HTTPAdditionalHeaders = addedHeaders
    manager = Alamofire.Manager(configuration: configuration)
  }
  
  static func getFullGoogleUrlWithPath(path: String) -> NSURL?{
    var urlString = googlePlacesBaseUrl+path+"&key=\(googlePlacesApiKey)"
    urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    return NSURL(string: urlString)
  }
  
  static func getFullUrlWithPath(path: String) -> NSURL?{
    let urlString = baseUrl+path
    return NSURL(string: urlString)
  }
  
}
