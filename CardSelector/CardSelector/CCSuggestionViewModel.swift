//
//  CCSuggestionViewModel.swift
//  CardSelector
//
//  Created by projas on 7/23/16.
//  Copyright © 2016 ABC. All rights reserved.
//
import Foundation
import ObjectMapper

class CCSuggestionViewModel {
  let suggestionService = CCSuggestionService()
  
  func getSuggestionsWithUser(user: CCUser, merchant: CCPlace, completion: (listSuggestions: [String]) -> Void, onError: (error: NSError) -> Void) {
    suggestionService.getSuggestionsWithUser(user, merchant: merchant, completion: { (jsonSuggestions) in
      completion(listSuggestions: jsonSuggestions as! [String])
    }) { (error) in
      onError(error: error)
    }
  }
  
}