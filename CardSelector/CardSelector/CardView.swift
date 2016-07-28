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
  @IBOutlet weak var cardTypeLabel: UILabel!
  @IBOutlet weak var cardLevelLabel: UILabel!
  @IBOutlet weak var endingLabel: UILabel!
  @IBOutlet weak var rateLabel: UILabel!
  @IBOutlet weak var cutoffLabel: UILabel!
  
  
  
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
    background.backgroundColor = UIColor.whiteColor()//card.color
    programLabel.text = card.cardProgram?.name
    cardTypeLabel.text = card.cardType?.name
    cardLevelLabel.text = (card.cardLevel!.isEnabled) ? card.cardLevel?.name : ""
    
    rateLabel.text = ""
    endingLabel.text = "••••"
    cutoffLabel.text = ""
  }

}
