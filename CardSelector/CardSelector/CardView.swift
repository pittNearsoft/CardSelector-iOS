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
  
  
  @IBOutlet weak var placeholder1Label: UILabel!
  @IBOutlet weak var placeholder2Label: UILabel!
  @IBOutlet weak var placeholder3Label: UILabel!
  
  
  let cardColors = [
    "Wells Fargo": UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0),
    "Bank of America": UIColor.white,
    "Chase": UIColor.white,
    "Citibank": UIColor.white,
    "PNC": UIColor(red:0.06, green:0.29, blue:0.53, alpha:1.0),
    "Capital One": UIColor(red:0.00, green:0.22, blue:0.44, alpha:1.0),
    "American Express": UIColor(red:0.00, green:0.31, blue:0.77, alpha:1.0),
    "Discover": UIColor.white,
    "Barclays": UIColor(red:0.00, green:0.68, blue:0.94, alpha:1.0)
  ]
  
  let textColors = [
    "Wells Fargo": UIColor.white,
    "Bank of America": UIColor.black,
    "Chase": UIColor.black,
    "Citibank": UIColor.black,
    "PNC": UIColor.white,
    "Capital One": UIColor.white,
    "American Express": UIColor.white,
    "Discover": UIColor.black,
    "Barclays": UIColor.white
  ]
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
    addSubview(cardView)
    cardView.translatesAutoresizingMaskIntoConstraints = false

    
    addConstraint(NSLayoutConstraint(item: cardView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0 ))
    
    addConstraint(NSLayoutConstraint(item: cardView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0 ))

  }
  
  func configureWithCard(card: CCCard) {
    let bankName = card.bank!.name
    
    bankImage.image = UIImage(named: bankName)
    background.backgroundColor = cardColors[bankName]//UIColor.whiteColor()//card.color
    programLabel.text = card.cardProgram?.name
    cardTypeLabel.text = card.cardType?.name
    cardLevelLabel.text = (card.cardLevel!.isEnabled) ? card.cardLevel?.name : ""
    
    rateLabel.text = ""
    endingLabel.text = "••••"
    cutoffLabel.text = ""
    
    
    
    programLabel.textColor = textColors[bankName]
    cardTypeLabel.textColor = textColors[bankName]
    cardLevelLabel.textColor = textColors[bankName]
    rateLabel.textColor = textColors[bankName]
    endingLabel.textColor = textColors[bankName]
    cutoffLabel.textColor = textColors[bankName]
    
    placeholder1Label.textColor = textColors[bankName]
    placeholder2Label.textColor = textColors[bankName]
    placeholder3Label.textColor = textColors[bankName]
  }

}
