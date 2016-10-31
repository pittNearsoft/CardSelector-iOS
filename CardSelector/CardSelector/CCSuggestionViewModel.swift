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
  
  func getSuggestionsWithUser(user: CCUser, merchant: CCPlace, completion: @escaping (_ listSuggestions: [CCSuggestion]) -> Void, onError: @escaping (_ error: NSError) -> Void) {
    suggestionService.getSuggestionsWithUser(user: user, merchant: merchant, completion: { (jsonSuggestions) in
      let suggestions: [CCSuggestion] = Mapper().mapArray(JSONArray: jsonSuggestions)!
      completion(suggestions)
    }) { (error) in
      onError(error)
    }
  }
  
}
