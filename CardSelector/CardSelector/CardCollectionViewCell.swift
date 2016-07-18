//
//  CardCollectionViewCell.swift
//  CardSelector
//
//  Created by projas on 7/14/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var card: CardView!
  @IBOutlet weak var checkImage: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    card.roundCorners()
  }
  
  static func reuseIdentifier() -> String {
    return "CardCollectionViewCell"
  }
  
  func configureCellWithCard(ccCard: CCCard) {
    if ccCard.bank?.name == "Bank Of America" {
      card.bankImage.image = UIImage(named: "america")
    }else if ccCard.bank?.name == "Chase"{
      card.bankImage.image = UIImage(named: "chase")
    }
    
    card.programLabel.text = ccCard.cardProgram?.name
  }
  
}
