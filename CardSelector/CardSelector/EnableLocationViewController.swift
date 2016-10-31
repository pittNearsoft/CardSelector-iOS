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
    collectionView.register(settingsNibName, forCellWithReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier())
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(shouldDismiss), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
  }
  
  
  func shouldDismiss() {
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      dismiss(animated: true, completion: nil)
    }
  }
  
  
  
}

extension EnableLocationViewController: UICollectionViewDataSource{
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsCollectionViewCell.reuseIdentifier(), for: indexPath) as! SettingsCollectionViewCell
    
    cell.settingsImageView.image = UIImage(named: "settings\(indexPath.row+1)")
    
    return cell
  }
}

extension EnableLocationViewController: UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height)
    
    
  }
}
