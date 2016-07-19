//
//  BankCollectionViewCell.swift
//  CardSelector
//
//  Created by projas on 7/18/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class BankCollectionViewCell: UICollectionViewCell {

  
  @IBOutlet weak var bankImage: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
//      bankImage.layer.borderWidth = 1
//      bankImage.layer.borderColor = UIColor.blackColor().CGColor
      bankImage.roundCorners()
    }
  
  static func reuseIdentifier() -> String {
    return "BankCollectionViewCell"
  }

}
