////
////  AlamofireExtensions.swift
////  CardSelector
////
////  Created by projas on 7/7/16.
////  Copyright © 2016 ABC. All rights reserved.
////
//
//import Alamofire
//
//extension Request {
//  
//  /**
//   Creates a customized response serializer that returns a JSON object constructed from the response data using
//   `NSJSONSerialization` with the specified reading options.
//   
//   - parameter options: The JSON serialization reading options. `.AllowFragments` by default.
//   
//   - returns: A JSON object response serializer.
//   */
//  static func CCJSONResponseSerializer(
//    options: NSJSONReadingOptions = .AllowFragments)
//    -> DataResponseSerializer<AnyObject>
//  {
//    return ResponseSerializer { _, response, data, error in
//      guard error == nil else { return .Failure(error!) }
//      
//      if let response = response , response.statusCode == 204 { return .Success(NSNull()) }
//      
//      guard let validData = data , validData.length > 0 else {
//        let failureReason = "JSON could not be serialized. Input data was nil or zero length."
//        let error = Error.error(code: .JSONSerializationFailed, failureReason: failureReason)
//        
//        return .Failure(error)
//      }
//      
//      do {
//        let JSON = try NSJSONSerialization.JSONObjectWithData(validData, options: options)
//        
//        return .Success(JSON)
//      } catch {
//        return .Failure(error as NSError)
//      }
//    }
//  }
//  
//  /**
//   Adds a handler to be called once the request has finished.
//   
//   - parameter options:           The JSON serialization reading options. `.AllowFragments` by default.
//   - parameter completionHandler: A closure to be executed once the request has finished.
//   
//   - returns: The request.
//   */
//  func CCresponseJSON(
//    queue: DispatchQueue? = nil,
//          options: JSONSerialization.ReadingOptions = .allowFragments,
//          completionHandler: (DataResponse<AnyObject>) -> Void)
//    -> Self
//  {
//    return response(
//      queue: queue,
//      responseSerializer: Request.CCJSONResponseSerializer(options: options),
//      completionHandler: completionHandler
//    )
//  }
//}
//
//
//extension Error{
//  static func error(domain: String = Error.Domain, code: Code, failureReason: String) -> NSError {
//    return error(domain: domain, code: code.rawValue, failureReason: failureReason)
//  }
//  
//  static func error(domain: String = Error.Domain, code: Int, failureReason: String) -> NSError {
//    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
//    return NSError(domain: domain, code: code, userInfo: userInfo)
//  }
//}
