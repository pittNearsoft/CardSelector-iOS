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
  
  var profileCards: [CCProfileCard] = []
  
  let cardViewModel = CCCardViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nibName = UINib(nibName: CardCell.reuseIdentifier(), bundle:nil)
    tableView.registerNib(nibName, forCellReuseIdentifier: CardCell.reuseIdentifier())
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 184 //104.0
    setupRefreshControl()
    getProfileCards()
  }
  
  func getProfileCards() {
    noCardsLabel.hidden = true
    SVProgressHUD.show()
    let user = CCUserViewModel.getLoggedUser()
    cardViewModel.getProfileCardsFromUser(user!, completion: { (listCards) in
      
      self.profileCards = listCards
      self.tableView.reloadData()
      self.dismissLoading()
    }) { (error) in
      print(error.localizedDescription)
      //Alert(title: "Error", message: "Please try again later.").showOkay()
      self.noCardsLabel.hidden = false
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
}
