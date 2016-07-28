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
      self.noCardsLabel.hidden = (profileCards.count > 0) ? true : false
    }
  }
  
  let cardViewModel = CCCardViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nibName = UINib(nibName: CardCell.reuseIdentifier(), bundle:nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: CardCell.reuseIdentifier())
    
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
    cardViewModel.getProfileCardsFromUser(user!, completion: { (listCards) in
      self.profileCards = listCards
      user?.profileCards = listCards
      CCUserViewModel.saveUserIntoUserDefaults(user!)
      
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
    refreshControl.tintColor = UIColor.whiteColor()
    tableView.addSubview(refreshControl)
    refreshControl.addTarget(self, action: #selector(getProfileCards), forControlEvents: .ValueChanged)
  }
  
  func dismissLoading() {
    SVProgressHUD.dismiss()
    refreshControl?.endRefreshing()
  }
  
  func deleteProfileCardWithIndexPath(indexPath: NSIndexPath) {
    let user = CCUserViewModel.getLoggedUser()
    
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.lock()
    cardViewModel.deleteCard(profileCards[indexPath.row], user: user!, completion: { (success) in
      cell?.unlock()
      self.profileCards.removeAtIndex(indexPath.row)
      user?.profileCards.removeAtIndex(indexPath.row)
      CCUserViewModel.saveUserIntoUserDefaults(user!)
      self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }) { (error) in
      cell?.unlock()
      print(error.localizedDescription)
      Alert(title: "Ops!", message: "Something went wrong in server. Try again later.").showOkay()
      
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "addCardSegue" {
      let navVC = segue.destinationViewController as! UINavigationController
      let addCardVC = navVC.viewControllers[0] as! AddCardViewController
      addCardVC.delegate = self
    }
  }
  
  func scrollToBottomIfNeeded() {
    let delay = 0.1 * Double(NSEC_PER_SEC)
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay)), dispatch_get_main_queue()) { () -> Void in
      if self.profileCards.count > 0 {
        let lastRowIndexPath = NSIndexPath(forRow: self.profileCards.count - 1, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(lastRowIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
      }
    }
  }
  
}

extension MyCardsViewController: UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return profileCards.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CardCell.reuseIdentifier(), forIndexPath: indexPath) as! CardCell

    cell.configureCellWithProfileCard(profileCards[indexPath.row])
    
    return cell
  }
}

extension MyCardsViewController: UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      
      
      Alert(message: "Do you really want to delete this card?")
        .addAction("Cancel")
        .addAction("Yes", style: .Destructive, handler: { _ in
          self.deleteProfileCardWithIndexPath(indexPath)
        }).show()
    }
  }
}

extension MyCardsViewController: AddCardViewControllerDelegate{
  func didSaveProfileCard(card: CCProfileCard) {
    profileCards.append(card)
    let user = CCUserViewModel.getLoggedUser()
    user?.profileCards.append(card)
    CCUserViewModel.saveUserIntoUserDefaults(user!)
    
    tableView.reloadData()
    scrollToBottomIfNeeded()
  }
}
