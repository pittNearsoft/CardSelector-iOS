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
import AKPickerView

class AddCardViewController: BaseViewController {
  
  
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var cardCollectionView: UICollectionView!
  @IBOutlet weak var bankCollectionView: UICollectionView!
  @IBOutlet weak var additionalInfoView: UIView!
  
  @IBOutlet weak var rateTextField: UITextField!
  
  
  @IBOutlet weak var cutoffPickerView: AKPickerView!
  @IBOutlet weak var noCardsLabel: UILabel!
  
  var delegate: AddCardViewControllerDelegate?
  
  
  let cardViewModel = CCCardViewModel()
  let bankViewModel = CCBankViewModel()
  
  var listCards: [CCCard] = []
  var listBanks: [CCBank] = []
  var selectedBank: CCBank?
  var selectedCard: CCCard?
  
  
  var selectedProfileCard = CCProfileCard()
  
  
  let cutoffDays = ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th",
                    "11th","12th","13th","14th","15th","16th","17th","18th","19th","20th",
                    "21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st"]
  
  
  @IBOutlet weak var ending1TextField: UITextField!
  @IBOutlet weak var ending2TextField: UITextField!
  @IBOutlet weak var ending3TextField: UITextField!
  @IBOutlet weak var ending4TextField: UITextField!
  
  var endingCardNumbers = ["","","",""]
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cardCollectionView.dataSource = self
    cardCollectionView.delegate = self
    
    bankCollectionView.dataSource = self
    bankCollectionView.delegate = self
    
    ending1TextField.delegate = self
    ending2TextField.delegate = self
    ending3TextField.delegate = self
    ending4TextField.delegate = self
    
    ending1TextField.addDoneButtonOnKeyboard()
    ending2TextField.addDoneButtonOnKeyboard()
    ending3TextField.addDoneButtonOnKeyboard()
    ending4TextField.addDoneButtonOnKeyboard()
    
    rateTextField.delegate = self
    rateTextField.addDoneButtonOnKeyboard()
    
    cutoffPickerView.dataSource = self
    cutoffPickerView.delegate = self
    cutoffPickerView.autoresizingMask = [.FlexibleWidth , .FlexibleHeight]
    cutoffPickerView.font = UIFont(name: "HelveticaNeue-Light", size: 20)
    cutoffPickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)
    cutoffPickerView.interitemSpacing = 20.0
    cutoffPickerView.fisheyeFactor = 0.001
    cutoffPickerView.pickerViewStyle = .Style3D
    cutoffPickerView.maskDisabled = false
    cutoffPickerView.selectItem(14, animated: true)
    
    
    
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
    
    SVProgressHUD.setDefaultStyle(.Light)
    getAvailableBanks()
  }
  
  func dismissKeyboard() {
    if ending1TextField.isFirstResponder() {
      ending1TextField.resignFirstResponder()
    }else if ending2TextField.isFirstResponder() {
      ending2TextField.resignFirstResponder()
    }else if ending3TextField.isFirstResponder() {
      ending3TextField.resignFirstResponder()
    }else if ending4TextField.isFirstResponder() {
      ending4TextField.resignFirstResponder()
    } else if rateTextField.isFirstResponder(){
      rateTextField.resignFirstResponder()
    }
  }
  
  @IBAction func saveCard(sender: AnyObject) {
    if selectedCard == nil {
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
    
//    if endingTextField.text!.isEmpty {
//      missingData.append("ending")
//    }else{
//      selectedProfileCard.endingCard = Int(endingTextField.text!)!
//    }
    
    let endingNumber = Int(endingCardNumbers.joinWithSeparator(""))
    
    if endingNumber == nil {
      missingData.append("ending")
    }else if endingNumber! < 1000 {
      Alert(title: "Ops!", message: "Card's ending is incomplete. Please add the rest of numbers").showOkay()
      return
    }
    selectedProfileCard.endingCard = endingNumber!
    
    
    if rateTextField.text!.isEmpty {
      missingData.append("interest rate")
    }else{
      
      let rateValue = Double(rateTextField.text!)!
      
      if rateValue > 100.0 || rateValue < 0{
        Alert(title: "Ops!", message: "Interest rate must be between 0-100%").showOkay()
        return
      }
      
      selectedProfileCard.interestRate = rateValue
    }
    
    let selectedCutoff = Int(cutoffPickerView.selectedItem)+1
    selectedProfileCard.cuttOffDay = selectedCutoff
    
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
    cardViewModel.saveCard(selectedProfileCard, user: user!, completion: { (success) in
      
      SVProgressHUD.dismiss()
      self.delegate?.didSaveProfileCard(self.selectedProfileCard)
      self.dismissViewControllerAnimated(true, completion: nil)
    }, onError: { (error) in
      SVProgressHUD.dismiss()
      Alert(title: "Error", message: "Couldn't save right now, try again later.").showOkay()
      print(error.localizedDescription)
    })
  }
  
  func getAvailableBanks() {

    SVProgressHUD.show()
    bankViewModel.getAvailableBanks({ (listBanks) in
      self.listBanks = listBanks
      self.listBanks[0].selected = true
      self.bankCollectionView.reloadData()
      
      if listBanks.count > 0{
        self.getAvailableCardsFromBank(listBanks[0])
      }
      
      SVProgressHUD.dismiss()
      
    }) { (error) in
      print(error.localizedDescription)
      SVProgressHUD.dismiss()
      Alert(title: "Ops!", message: "Banks weren't found. Please try again later.").showOkay()
      self.dismissViewControllerAnimated(true, completion: nil)
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
    
    let user = CCUserViewModel.getLoggedUser()
    cardViewModel.getAvailableCardsFromBank(bank, user: user! ,
      completion: { (listCards) in
        

        self.noCardsLabel.hidden = (listCards.count == 0) ? false : true
        
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
    animateViewMoving(heightConstraint,moveValue: 260, curve: UIViewAnimationOptions.CurveLinear.rawValue, duration: 0.3)
  }
  
  func hideAdditionalInfo() {
    animateViewMoving(heightConstraint,moveValue: 0, curve: UIViewAnimationOptions.CurveLinear.rawValue, duration: 0.3)
    dismissKeyboard()
  }
  
}

extension AddCardViewController: UITextFieldDelegate{
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    
    
    switch textField {
    case ending1TextField:
      endingCardNumbers[0] = string
    case ending2TextField:
      endingCardNumbers[1] = string
    case ending3TextField:
      endingCardNumbers[2] = string
    case ending4TextField:
      endingCardNumbers[3] = string
    default:
      break
    }
    
    
    
    if textField == ending1TextField || textField == ending2TextField || textField == ending3TextField || textField == ending4TextField {
      let newLength = text.utf16.count + string.utf16.count - range.length
      return newLength <= 1
    }
    
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
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
      
      let bank = listBanks[indexPath.row]
      
      if bank.selected {
        selectedBank = bank
      }
      
      cell.configureCellWithBank(bank)
      return cell
    }
    
    
    
  
  }
}

extension AddCardViewController: UICollectionViewDelegate{
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    if collectionView == self.cardCollectionView {
      
      let card = listCards[indexPath.row]

      //Compare if user has selected another card, if yes, proceed within if condition
      if selectedCard != card {
        selectedCard?.selected = false
        card.selected = !card.selected
        selectedCard = card
        selectedProfileCard.card = selectedCard
        showAdditionalInfo()
      }else{
        selectedCard?.selected = !selectedCard!.selected
        selectedCard = nil
        selectedProfileCard.card = nil
        hideAdditionalInfo()
      }

      cardCollectionView.reloadData()
    }else{
      
      //Ignore operations if user has selected the same selected bank
      if listBanks[indexPath.row] == selectedBank {
        return
      }
      
      //Otherwise, replace the new selected bank and update the table (with a check for the bank)
      selectedBank?.selected = false
      selectedBank = listBanks[indexPath.row]
      selectedBank!.selected = true
      bankCollectionView.reloadData()
      
      self.getAvailableCardsFromBank(selectedBank!)
      
      if selectedCard != nil {
        selectedCard?.selected = false
        selectedCard = nil
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
      return CGSize(width: 310 , height: cardCollectionView.frame.height)
    }else{
      return CGSize(width: 85, height: 70)
    }
    
    
  }
}

extension AddCardViewController: AKPickerViewDataSource{
  func numberOfItemsInPickerView(pickerView: AKPickerView!) -> UInt {
    return UInt(cutoffDays.count)
  }
  
  func pickerView(pickerView: AKPickerView!, titleForItem item: Int) -> String! {
    return cutoffDays[item]
  }
}

extension AddCardViewController: AKPickerViewDelegate{
  func pickerView(pickerView: AKPickerView!, didSelectItem item: Int) {
    print(cutoffDays[item])
  }
}

protocol AddCardViewControllerDelegate {
  func didSaveProfileCard(card: CCProfileCard)
}