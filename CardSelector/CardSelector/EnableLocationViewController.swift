//
//  EnableLocationViewController.swift
//  CardSelector
//
//  Created by projas on 7/24/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import CoreLocation

class EnableLocationViewController: UIViewController {
  
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    let settingsNibName = UINib(nibName: SettingsCollectionViewCell.reuseIdentifier(), bundle:nil)
    collectionView.registerNib(settingsNibName, forCellWithReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier())
    
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(shouldDismiss), name: UIApplicationDidBecomeActiveNotification, object: nil)
  }
  
  
  func shouldDismiss() {
    if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  
  
}

extension EnableLocationViewController: UICollectionViewDataSource{
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SettingsCollectionViewCell.reuseIdentifier(), forIndexPath: indexPath) as! SettingsCollectionViewCell
    
    cell.settingsImageView.image = UIImage(named: "settings\(indexPath.row+1)")
    
    return cell
  }
}

extension EnableLocationViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    
    return 10
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height)
    
    
  }
}