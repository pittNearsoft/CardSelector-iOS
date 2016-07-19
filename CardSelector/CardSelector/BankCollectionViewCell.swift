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
  @IBOutlet weak var selectImage: UIImageView!
  @IBOutlet weak var selectedView: UIView!
  
  var checked: Bool = false {
    willSet{
      if newValue == true {
        didSelect()
      }else{
        didUnselect()
      }
    }
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
//      bankImage.layer.borderWidth = 1
//      bankImage.layer.borderColor = UIColor.blackColor().CGColor
      bankImage.roundCorners()
      selectedView.roundCorners()
    }
  
  static func reuseIdentifier() -> String {
    return "BankCollectionViewCell"
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
