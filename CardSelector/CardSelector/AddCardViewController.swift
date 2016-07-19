//
//  AddCardViewController.swift
//  CardSelector
//
//  Created by projas on 7/14/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddCardViewController: UIViewController {
  
  @IBOutlet weak var cardCollectionView: UICollectionView!
  @IBOutlet weak var bankCollectionView: UICollectionView!
  
  let cardViewModel = CCCardViewModel()
  
  var listCards: [CCCard] = []
  var listBanks: [CCBank] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cardCollectionView.dataSource = self
    cardCollectionView.delegate = self
    
    bankCollectionView.dataSource = self
    bankCollectionView.delegate = self
    
    let cardNibName = UINib(nibName: CardCollectionViewCell.reuseIdentifier(), bundle:nil)
    cardCollectionView.registerNib(cardNibName, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier())
    
    let bankNibName = UINib(nibName: BankCollectionViewCell.reuseIdentifier(), bundle:nil)
    bankCollectionView.registerNib(bankNibName, forCellWithReuseIdentifier: BankCollectionViewCell.reuseIdentifier())
    
    
    listBanks.append(CCBank(bankId: 1, name: "Chase", description: ""))
    listBanks.append(CCBank(bankId: 2, name: "Bank Of America", description: ""))
    listBanks.append(CCBank(bankId: 3, name: "wells", description: ""))
    
    listBanks.append(CCBank(bankId: 1, name: "Chase", description: ""))
    listBanks.append(CCBank(bankId: 2, name: "Bank Of America", description: ""))
    listBanks.append(CCBank(bankId: 3, name: "wells", description: ""))
    
    listBanks.append(CCBank(bankId: 1, name: "Chase", description: ""))
    listBanks.append(CCBank(bankId: 2, name: "Bank Of America", description: ""))
    listBanks.append(CCBank(bankId: 3, name: "wells", description: ""))
    
    getAvailableCards()
  }
  
  @IBAction func saveCard(sender: AnyObject) {
    print("Save data here!")
  }
  
  
  @IBAction func cancelOperation(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func getAvailableCards() {
    
    cardCollectionView.lock()
    cardViewModel.getAvailableCards({ (listCards) in
      self.listCards = listCards
      self.cardCollectionView.reloadData()
      self.cardCollectionView.unlock()
      }) { (error) in
        print(error.localizedDescription)
        self.cardCollectionView.unlock()
    }
  }
  
}


extension AddCardViewController: UICollectionViewDataSource{
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.cardCollectionView {
      return listCards.count
    }else {
      return listBanks.count
    }
    
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    if collectionView == self.cardCollectionView {
      let cell = cardCollectionView.dequeueReusableCellWithReuseIdentifier(CardCollectionViewCell.reuseIdentifier(), forIndexPath: indexPath) as! CardCollectionViewCell
    
      cell.configureCellWithCard(listCards[indexPath.row])
      return cell
    } else{
      let cell = bankCollectionView.dequeueReusableCellWithReuseIdentifier(BankCollectionViewCell.reuseIdentifier(), forIndexPath: indexPath) as! BankCollectionViewCell
      
      cell.bankImage.image = UIImage(named: listBanks[indexPath.row].name)
      return cell
    }
    
    
    
  
  }
}

extension AddCardViewController: UICollectionViewDelegate{
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    if collectionView == self.cardCollectionView {
      let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CardCollectionViewCell
      cell.checkImage.hidden = !cell.checkImage.hidden
    }else{
      let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BankCollectionViewCell
      cell.checked = !cell.checked
    }
    
  }
}

extension AddCardViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    
    if collectionView == self.cardCollectionView {
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }else{
      return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    
    if collectionView == self.cardCollectionView {
      return 0
    }else{
      return 10
    }
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    if collectionView == self.cardCollectionView {
      return 0
    }else{
      return 10
    }
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    if collectionView == self.cardCollectionView {
      return CGSize(width: cardCollectionView.frame.width, height: cardCollectionView.frame.height)
    }else{
      return CGSize(width: 85, height: 70)
    }
    
    
  }
}