//
//  CardCell.swift
//  CardSelector
//
//  Created by projas on 7/12/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
  
  
  @IBOutlet weak var cardView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      cardView.roundCorners()
      
//      let card = CardView(frame: CGRect(x: 0, y: 0, width: 338, height: 168))
//      
//      addSubview(card)
//      
//      card.backgroundColor = UIColor.whiteColor()
//      
//      
      //self.frame = CGRect(x: 0, y: 0, width: 359, height: 184)
      
      
//      let card = NSBundle.mainBundle().loadNibNamed("CardView", owner: self, options: nil).first as! CardView
//      card.roundCorners()
////      card.frame = CGRect(x: 0, y: 0, width: 338, height: 168)
//      
//      addSubview(card)
//      
//      
//      
//      addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": card]))
//      
//      addConstraint(NSLayoutConstraint(item: card, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0 ) )

      
      //card.center = self.center
    }
  
  static func reuseIdentifier() -> String {
    return "CardCell"
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
