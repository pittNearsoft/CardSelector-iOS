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
    
    var endingCard = "••••"
    if profileCard.endingCard >= 0 && profileCard.endingCard < 10 {
      endingCard = "000\(profileCard.endingCard)"
    }else if profileCard.endingCard >= 10 && profileCard.endingCard < 100 {
      endingCard = "00\(profileCard.endingCard)"
    }else if profileCard.endingCard >= 100 && profileCard.endingCard < 1000 {
      endingCard = "0\(profileCard.endingCard)"
    }else if profileCard.endingCard >= 1000 && profileCard.endingCard < 10000{
      endingCard = "\(profileCard.endingCard)"
    }

    card.endingLabel.text = endingCard
    card.rateLabel.text = (profileCard.interestRate != -1) ? "APR: \(profileCard.interestRate)%" :  "APR: \(profileCard.card!.defaultRate)%"
    card.cutoffLabel.text = "Cutoff day: \(profileCard.cuttOffDay)"
    
  }
  
}
