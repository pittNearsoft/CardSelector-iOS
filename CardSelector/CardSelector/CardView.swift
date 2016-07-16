//
//  CardView.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class CardView: UIView {

  @IBOutlet var card: UIView!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    NSBundle.mainBundle().loadNibNamed("CardView", owner: self, options: nil)
    addSubview(card)
    card.translatesAutoresizingMaskIntoConstraints = false

    
    addConstraint(NSLayoutConstraint(item: card, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0 ))
    
    addConstraint(NSLayoutConstraint(item: card, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0 ))

  }

}
