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

class MyCardsViewController: UIViewController {
  
  
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
    getProfileCards()
  }
  
  func getProfileCards() {
    
    SVProgressHUD.show()
    let user = CCUserViewModel.getLoggedUser()
    cardViewModel.getProfileCardsFromUser(user!, completion: { (listCards) in
      self.profileCards = listCards
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
      self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }) { (error) in
      cell?.unlock()
      print(error.localizedDescription)
      Alert(title: "Ops!", message: "Something went wrong in server. Try again later.").showOkay()
      
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
      deleteProfileCardWithIndexPath(indexPath)
    }
  }
}
