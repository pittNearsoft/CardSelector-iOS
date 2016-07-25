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
  
  func configureCellWithProfileCard(profileCard: CCProfileCard) {
    card.configureWithCard(profileCard.card!)
    
    if profileCard.endingCard != -1 {
      card.endingLabel.text = String(profileCard.endingCard)
      //card.endingLabel.font = UIFont(name: "Helvetica", size: 15)
    }
    
    if profileCard.interestRate != -1 {
      card.rateLabel.text = "Rate: \(profileCard.interestRate)%"
    }
  }
  
}
