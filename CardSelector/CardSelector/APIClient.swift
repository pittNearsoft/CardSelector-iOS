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
  
  var manager: SessionManager!
  
  init(){
    let configuration  = URLSessionConfiguration.default
    
//    var addedHeaders = manager .defaultHTTPHeaders
//    addedHeaders["Authorization"] = "Basic QWRtaW46QzRyZEMwbXA0ZHIzOjVFOTA3ODRSRg=="
//    
//    configuration.httpAdditionalHeaders = addedHeaders
    manager = Alamofire.SessionManager(configuration: configuration)
  }
  
  static func getFullGoogleUrlWithPath(path: String) -> URL?{
    var urlString = googlePlacesBaseUrl+path+"&key=\(googlePlacesApiKey)"
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    return URL(string: urlString)
  }
  
  static func getFullUrlWithPath(path: String) -> URL?{
    let urlString = baseUrl+path
    return URL(string: urlString)
  }
  
}
