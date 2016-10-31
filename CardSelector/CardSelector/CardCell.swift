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
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    
  }
  
  func configureCellWithCard(ccCard: CCCard) {
    card.configureWithCard(card: ccCard)
  }
  
  func configureCellWithProfileCard(profileCard: CCProfileCard) {
    card.configureWithCard(card: profileCard.card!)
    

    card.endingLabel.text = (profileCard.endingCard != -1 ) ? String(profileCard.endingCard) : "••••"
    card.rateLabel.text = (profileCard.interestRate != -1) ? "APR: \(profileCard.interestRate)%" :  "APR: \(profileCard.card!.defaultRate)%"
    card.cutoffLabel.text = "Cutoff day: \(profileCard.cuttOffDay)"
    
  }
  
}
