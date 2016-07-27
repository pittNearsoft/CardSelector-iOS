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
  @IBOutlet weak var selectImage: UIImageView!
  
  @IBOutlet weak var selectedView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    card.roundCorners()
  }
  
  static func reuseIdentifier() -> String {
    return "CardCollectionViewCell"
  }
  
  func configureCellWithCard(ccCard: CCCard) {
    
    if ccCard.selected {
      didSelect()
    }else{
      didUnselect()
    }
    
    card.configureWithCard(ccCard)
  }
  
  private func didSelect() {
    selectImage.hidden = false
    selectedView.hidden = false
  }
  
  private func didUnselect() {
    selectImage.hidden = true
    selectedView.hidden = true
  }
  
}
