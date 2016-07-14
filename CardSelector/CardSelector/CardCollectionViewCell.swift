//
//  CardCollectionViewCell.swift
//  CardSelector
//
//  Created by projas on 7/14/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    
    
    
    
    let card = NSBundle.mainBundle().loadNibNamed("CardView", owner: self, options: nil).first as! CardView
    card.roundCorners()
    //card.frame = CGRect(x: 0, y: 0, width: 338, height: 168)
    

    //card.frame = CGRect(x: 0, y: 0, width: frame.width-40, height: frame.height-80)
    card.frame = CGRect(x: 0, y: 0, width: frame.width*(0.88), height: frame.height*(0.48))
    
    addSubview(card)
    
    
    
//    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": card]))
//    
//    addConstraint(NSLayoutConstraint(item: card, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0 ) )
//    
//    addConstraint(NSLayoutConstraint(item: card, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0 ) )
    
    
    card.center = self.center
  }
  
  static func reuseIdentifier() -> String {
    return "CardCollectionViewCell"
  }
  
}
