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
  
  func configureCellWithBank(bank: CCBank) {
    
    if bank.selected {
      didSelect()
    }else{
      didUnselect()
    }
    
    bankImage.image = UIImage(named: bank.name)
  }
  
  private func didSelect() {
    selectImage.isHidden = false
    selectedView.isHidden = false
  }
  
  private func didUnselect() {
    selectImage.isHidden = true
    selectedView.isHidden = true
  }
  
}
