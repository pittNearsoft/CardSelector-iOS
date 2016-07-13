//
//  MyCardsViewController.swift
//  CardSelector
//
//  Created by projas on 7/11/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class MyCardsViewController: UIViewController {

  
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let nibName = UINib(nibName: CardCell.reuseIdentifier(), bundle:nil)
      tableView.registerNib(nibName, forCellReuseIdentifier: CardCell.reuseIdentifier())
      
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 200 //104.0
    }

}

extension MyCardsViewController: UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CardCell.reuseIdentifier(), forIndexPath: indexPath) as! CardCell
    return cell
  }
}
