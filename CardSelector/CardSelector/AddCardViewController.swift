//
//  AddCardViewController.swift
//  CardSelector
//
//  Created by projas on 7/14/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import SVProgressHUD
import LKAlertController

class AddCardViewController: BaseViewController {
  
  
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var cardCollectionView: UICollectionView!
  @IBOutlet weak var bankCollectionView: UICollectionView!
  @IBOutlet weak var additionalInfoView: UIView!
  
  @IBOutlet weak var endingTextField: UITextField!
  @IBOutlet weak var rateTextField: UITextField!
  
  @IBOutlet weak var noCardsLabel: UILabel!
  
  var delegate: AddCardViewControllerDelegate?
  
  
  let cardViewModel = CCCardViewModel()
  let bankViewModel = CCBankViewModel()
  
  var listCards: [CCCard] = []
  var listBanks: [CCBank] = []
  var selectedBankCell: BankCollectionViewCell?
  var selectedCardCell: CardCollectionViewCell?
  
  var selectedCard = CCProfileCard()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cardCollectionView.dataSource = self
    cardCollectionView.delegate = self
    
    bankCollectionView.dataSource = self
    bankCollectionView.delegate = self
    
    endingTextField.delegate = self
    rateTextField.delegate = self
    
    let cardNibName = UINib(nibName: CardCollectionViewCell.reuseIdentifier(), bundle:nil)
    cardCollectionView.registerNib(cardNibName, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier())
    
    let bankNibName = UINib(nibName: BankCollectionViewCell.reuseIdentifier(), bundle:nil)
    bankCollectionView.registerNib(bankNibName, forCellWithReuseIdentifier: BankCollectionViewCell.reuseIdentifier())
    
    
    //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    additionalInfoView.addGestureRecognizer(tap)
    
    heightConstraint.constant = 0
    
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
    if selectedCardCell == nil {
      Alert(title: "Ops!", message: "Please select a card before saving!").showOkay()
    }else{
      confirmSaving()
    }
  }
  
  
  @IBAction func cancelOperation(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func confirmSaving() {
    var missingData: [String] = []
    
    if endingTextField.text!.isEmpty {
      missingData.append("ending")
    }else{
      selectedCard.endingCard = Int(endingTextField.text!)!
    }
    
    if rateTextField.text!.isEmpty {
      missingData.append("rate")
    }else{
      selectedCard.interestRate = Double(rateTextField.text!)!
    }
    
    var message = "Are you ready to save?"
    if missingData.count == 2 {
      message = "\(missingData[0].capitalizedString) and \(missingData[1]) are blank. Do you want to save anyway?"
    }else if missingData.count == 1 {
      message = "\(missingData[0].capitalizedString) is blank. Do you want to save anyway?"
    }
    
    ActionSheet(message: message)
      .addAction("Cancel")
      .addAction("Yes", style: .Default, handler: { _  in
        self.dismissKeyboard()
        self.proceedToSave()
      }).show()
  }
  
  func proceedToSave() {
    SVProgressHUD.show()
    
    let user = CCUserViewModel.getLoggedUser()
    cardViewModel.saveCard(selectedCard, user: user!, completion: { (success) in
      
      SVProgressHUD.dismiss()
      self.delegate?.didSaveProfileCard(self.selectedCard)
      self.dismissViewControllerAnimated(true, completion: nil)
    }, onError: { (error) in
      SVProgressHUD.dismiss()
      Alert(title: "Error", message: "Couldn't save right now, try again later.").showOkay()
      print(error.localizedDescription)
    })
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
  
  func showAdditionalInfo() {
    animateViewMoving(heightConstraint,moveValue: 203, curve: UIViewAnimationOptions.CurveLinear.rawValue, duration: 0.3)
  }
  
  func hideAdditionalInfo() {
    animateViewMoving(heightConstraint,moveValue: 0, curve: UIViewAnimationOptions.CurveLinear.rawValue, duration: 0.3)
    dismissKeyboard()
  }
  
}

extension AddCardViewController: UITextFieldDelegate{
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    
    if textField == endingTextField {
      let newLength = text.utf16.count + string.utf16.count - range.length
      return newLength <= 4 // Bool
    }
    
    return true
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
        selectedBankCell = cell
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

      if selectedCardCell != cell {
        cell.checked = !cell.checked
        selectedCardCell = cell
        selectedCard.card = listCards[indexPath.row]
        showAdditionalInfo()
      }else{
        selectedCardCell?.checked = !selectedCardCell!.checked
        selectedCardCell = nil
        selectedCard.card = nil
        hideAdditionalInfo()
      }

      
    }else{
      
      selectedBankCell?.checked = false
      
      let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BankCollectionViewCell
      cell.checked = !cell.checked
      selectedBankCell = cell
      
      self.getAvailableCardsFromBank(listBanks[indexPath.row])
      
      if selectedCardCell != nil {
        selectedCardCell!.checked = false
        selectedCardCell = nil
        hideAdditionalInfo()
      }
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

protocol AddCardViewControllerDelegate {
  func didSaveProfileCard(card: CCProfileCard)
}