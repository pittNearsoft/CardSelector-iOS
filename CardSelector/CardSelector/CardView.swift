//
//  CardView.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class CardView: UIView {

  @IBOutlet var cardView: UIView!
  
  @IBOutlet weak var bankImage: UIImageView!
  @IBOutlet weak var background: UIView!
  @IBOutlet weak var programLabel: UILabel!
  
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    NSBundle.mainBundle().loadNibNamed("CardView", owner: self, options: nil)
    addSubview(cardView)
    cardView.translatesAutoresizingMaskIntoConstraints = false

    
    addConstraint(NSLayoutConstraint(item: cardView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0 ))
    
    addConstraint(NSLayoutConstraint(item: cardView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0 ))

  }
  
  func configureWithCard(card: CCCard) {
    bankImage.image = UIImage(named: (card.bank?.name)!)
    background.backgroundColor = card.color
    programLabel.text = card.cardProgram?.name
  }

}
