//
//  AddCardViewController.swift
//  CardSelector
//
//  Created by projas on 7/14/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController {
  
  @IBOutlet weak var cardCollectionView: UICollectionView!
  
  let cardViewModel = CCCardViewModel()
  
  var listCards: [CCCard] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cardCollectionView.dataSource = self
    cardCollectionView.delegate = self
    
    let nibName = UINib(nibName: CardCollectionViewCell.reuseIdentifier(), bundle:nil)
    cardCollectionView.registerNib(nibName, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier())
    getAvailableCards()
  }
  
  @IBAction func saveCard(sender: AnyObject) {
    print("Save data here!")
  }
  
  
  @IBAction func cancelOperation(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func getAvailableCards() {

    cardViewModel.getAvailableCards({ (listCards) in
      self.listCards = listCards
      self.cardCollectionView.reloadData()
      }) { (error) in
        print(error.localizedDescription)
    }
  }
  
}


extension AddCardViewController: UICollectionViewDataSource{
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return listCards.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = cardCollectionView.dequeueReusableCellWithReuseIdentifier(CardCollectionViewCell.reuseIdentifier(), forIndexPath: indexPath) as! CardCollectionViewCell
    
    cell.configureCellWithCard(listCards[indexPath.row])
    
    return cell
  }
}

extension AddCardViewController: UICollectionViewDelegate{
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CardCollectionViewCell
    cell.checkImage.hidden = !cell.checkImage.hidden
  }
}

extension AddCardViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSize(width: cardCollectionView.frame.width, height: cardCollectionView.frame.height)
  }
}