//
//  SuggestionViewCell.swift
//  CardSelector
//
//  Created by projas on 7/23/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class SuggestionViewCell: UITableViewCell {
  
  
  @IBOutlet weak var bankImage: UIImageView!
  @IBOutlet weak var suggestionDescription: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()

  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }
  
  func configureWithSuggestion(suggestion: CCSuggestion) {
    bankImage.image = UIImage(named: suggestion.bankName)
    suggestionDescription.text = suggestion.message
  }
  
}
