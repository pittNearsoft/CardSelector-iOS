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
  
  
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var cardCollectionView: UICollectionView!
  @IBOutlet weak var bankCollectionView: UICollectionView!
  @IBOutlet weak var additionalInfoView: UIView!
  
  @IBOutlet weak var endingTextField: UITextField!
  @IBOutlet weak var rateTextField: UITextField!
  
  @IBOutlet weak var noCardsLabel: UILabel!
  
  
  let cardViewModel = CCCardViewModel()
  let bankViewModel = CCBankViewModel()
  
  var listCards: [CCCard] = []
  var listBanks: [CCBank] = []
  var selectedBank: BankCollectionViewCell?
  var selectedCard: CardCollectionViewCell?
  
  
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
    
    
    //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    additionalInfoView.addGestureRecognizer(tap)
    
    heightConstraint.constant = 0
    
//    listBanks.append(CCBank(bankId: 1, name: "Chase", description: ""))
//    listBanks.append(CCBank(bankId: 2, name: "Bank Of America", description: ""))
//    listBanks.append(CCBank(bankId: 3, name: "wells", description: ""))
    
    
    //Nofitication to up or down text field when keyboard appear/disappear
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillShowWithNotification), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillHideWithNotification), name: UIKeyboardWillHideNotification, object: nil)
    
    getAvailableBanks()
    //getAvailableCards()
  }
  
  func dismissKeyboard() {
    if endingTextField.isFirstResponder() {
      endingTextField.resignFirstResponder()
    } else if rateTextField.isFirstResponder(){
      rateTextField.resignFirstResponder()
    }
  }
  
  @IBAction func saveCard(sender: AnyObject) {
    print("Save data here!")
  }
  
  
  @IBAction func cancelOperation(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func getAvailableBanks() {
    //bankCollectionView.lock()
    SVProgressHUD.show()
    bankViewModel.getAvailableBanks({ (listBanks) in
      self.listBanks = listBanks
      self.bankCollectionView.reloadData()
      
      if listBanks.count > 0{
        self.getAvailableCardsFromBank(listBanks[0])
      }
      
      //self.bankCollectionView.unlock()
      SVProgressHUD.dismiss()
      
    }) { (error) in
        print(error.localizedDescription)
        //self.bankCollectionView.unlock()
      SVProgressHUD.dismiss()
    }
  }
  
  func getAvailableCards() {
    
    self.noCardsLabel.hidden = true
    cardCollectionView.lock()
    cardViewModel.getAvailableCards({ (listCards) in
      self.listCards = listCards
      self.cardCollectionView.reloadData()
      self.cardCollectionView.unlock()
      }) { (error) in
        self.noCardsLabel.hidden = false
        print(error.localizedDescription)
        self.cardCollectionView.unlock()
    }
    

  }
  
  func getAvailableCardsFromBank(bank: CCBank) {
    
    self.noCardsLabel.hidden = true
    cardCollectionView.lock()
    cardViewModel.getAvailableCardsFromBank(bank,
      completion: { (listCards) in
        self.listCards = listCards
        self.cardCollectionView.reloadData()
        self.cardCollectionView.unlock()
        
      },
      onError: { error in
        self.noCardsLabel.hidden = false
        print(error.localizedDescription)
        self.cardCollectionView.unlock()
      }
    )
  }

  
  func handleKeyboardWillShowWithNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        animateViewMoving(bottomConstraint,moveValue: keyboardFrame.size.height, curve: curve,duration: duration)
      }
    }
    
  }
  
  func handleKeyboardWillHideWithNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      
      let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
      let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
      animateViewMoving(bottomConstraint,moveValue: 0, curve: curve,duration: duration)
    }
  }
  
  func animateViewMoving (constraint: NSLayoutConstraint,moveValue :CGFloat, curve: UInt, duration: Double){
    constraint.constant = moveValue
    let options = UIViewAnimationOptions(rawValue: curve << 16)
    UIView.animateWithDuration(duration, delay: 0, options: options,animations: {
        self.view.layoutIfNeeded()
      },completion: nil
    )
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
      
      if indexPath.row == 0 {
        cell.checked = true
        selectedBank = cell
      }
      
      cell.bankImage.image = UIImage(named: listBanks[indexPath.row].name)
      return cell
    }
    
    
    
  
  }
}

extension AddCardViewController: UICollectionViewDelegate{
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    if collectionView == self.cardCollectionView {
      
      
      let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CardCollectionViewCell

      if selectedCard != cell {
        cell.checked = !cell.checked
        selectedCard = cell
        animateViewMoving(heightConstraint,moveValue: 203, curve: UIViewAnimationOptions.CurveLinear.rawValue, duration: 0.3)
      }else{
        selectedCard?.checked = !selectedCard!.checked
        selectedCard = nil
        animateViewMoving(heightConstraint,moveValue: 0, curve: UIViewAnimationOptions.CurveLinear.rawValue, duration: 0.3)
        dismissKeyboard()
      }

      
    }else{
      
      selectedBank?.checked = false
      
      let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BankCollectionViewCell
      cell.checked = !cell.checked
      selectedBank = cell
      
      self.getAvailableCardsFromBank(listBanks[indexPath.row])
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