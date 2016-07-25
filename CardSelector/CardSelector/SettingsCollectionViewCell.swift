//
//  SettingsCollectionViewCell.swift
//  CardSelector
//
//  Created by projas on 7/24/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var settingsImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  static func reuseIdentifier() -> String{
    return "SettingsCollectionViewCell"
  }
  
}
