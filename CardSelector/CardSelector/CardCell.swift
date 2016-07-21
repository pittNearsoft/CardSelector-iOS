//
//  CardCell.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
  
  
  @IBOutlet weak var card: CardView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    card.roundCorners()
  }
  
  static func reuseIdentifier() -> String {
    return "CardCell"
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    
  }
  
  func configureCellWithCard(ccCard: CCCard) {
    card.configureWithCard(ccCard)
  }
  
}
