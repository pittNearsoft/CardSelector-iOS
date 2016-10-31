//
//  MyCardsViewController.swift
//  CardSelector
//
//  Created by projas on 7/11/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import SVProgressHUD
import LKAlertController

class MyCardsViewController: BaseViewController {
  
  
  @IBOutlet weak var noCardsLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var refreshControl: UIRefreshControl!
  
  var profileCards: [CCProfileCard] = [] {
    didSet{
      self.noCardsLabel.isHidden = (profileCards.count > 0) ? true : false
    }
  }
  
  let cardViewModel = CCCardViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nibName = UINib(nibName: CardCell.reuseIdentifier(), bundle:nil)
    tableView.register(nibName, forCellReuseIdentifier: CardCell.reuseIdentifier())
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 184 //104.0
    
    tableView.allowsMultipleSelectionDuringEditing = false
    
    setupRefreshControl()
    
    let user = CCUserViewModel.getLoggedUser()
    profileCards = user!.profileCards
    //getProfileCards()
  }
  
  func getProfileCards() {
    
    SVProgressHUD.show()
    let user = CCUserViewModel.getLoggedUser()
    cardViewModel.getProfileCardsFromUser(user: user!, completion: { (listCards) in
      self.profileCards = listCards
      user?.profileCards = listCards
      CCUserViewModel.saveUserIntoUserDefaults(user: user!)
      
      self.tableView.reloadData()
      self.dismissLoading()
    }) { (error) in
      print(error.localizedDescription)
      //Alert(title: "Error", message: "Please try again later.").showOkay()
      self.dismissLoading()
    }
  }
  
  func setupRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.white
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: #selector(getProfileCards), for: .valueChanged)
  }
  
  func dismissLoading() {
    SVProgressHUD.dismiss()
    refreshControl?.endRefreshing()
  }
  
  func deleteProfileCardWithIndexPath(indexPath: IndexPath) {
    let user = CCUserViewModel.getLoggedUser()
    
    let cell = tableView.cellForRow(at: indexPath)
    cell?.lock()
    cardViewModel.deleteCard(card: profileCards[indexPath.row], user: user!, completion: { (success) in
      cell?.unlock()
      self.profileCards.remove(at: indexPath.row)
      user?.profileCards.remove(at: indexPath.row)
      CCUserViewModel.saveUserIntoUserDefaults(user: user!)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
    }) { (error) in
      cell?.unlock()
      print(error.localizedDescription)
      Alert(title: "Oops!", message: "Something went wrong in server. Try again later.").showOkay()
      
    }
  }
  

  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "addCardSegue" {
      let navVC = segue.destination as! UINavigationController
      let addCardVC = navVC.viewControllers[0] as! AddCardViewController
      addCardVC.delegate = self
    }
  }
  
  func scrollToBottomIfNeeded() {
    //let delay = 0.1 * Double(NSEC_PER_SEC)
    
//    dispatch_after(DispatchTime.now(dispatch_time_t(DispatchTime.now), Int64(delay)), DispatchQueue.main) { () -> Void in
//      if self.profileCards.count > 0 {
//        let lastRowIndexPath = NSIndexPath(forRow: self.profileCards.count - 1, inSection: 0)
//        self.tableView.scrollToRowAtIndexPath(lastRowIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
//      }
//    }
//    
    DispatchQueue.main.async {
      if self.profileCards.count > 0 {
        let lastRowIndexPath = IndexPath(row: self.profileCards.count - 1, section: 0)
        self.tableView.scrollToRow(at: lastRowIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
      }
    }
  }
  
}

extension MyCardsViewController: UITableViewDataSource{
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return profileCards.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.reuseIdentifier(), for: indexPath) as! CardCell
    
    cell.configureCellWithProfileCard(profileCard: profileCards[indexPath.row])
    
    return cell
  }
}

extension MyCardsViewController: UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  @objc(tableView:canFocusRowAtIndexPath:) func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
    return true
  }


  @objc(tableView:commitEditingStyle:forRowAtIndexPath:) func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
      
      Alert(message: "Do you really want to delete this card?")
        .addAction("Cancel")
        .addAction("Yes", style: .destructive, handler: { _ in
          self.deleteProfileCardWithIndexPath(indexPath: indexPath)
        }).show()
    }
  }
}

extension MyCardsViewController: AddCardViewControllerDelegate{
  func didSaveProfileCard(card: CCProfileCard) {
    profileCards.append(card)
    let user = CCUserViewModel.getLoggedUser()
    user?.profileCards.append(card)
    CCUserViewModel.saveUserIntoUserDefaults(user: user!)
    
    tableView.reloadData()
    scrollToBottomIfNeeded()
  }
}
