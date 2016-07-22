//
//  MainViewController.swift
//  CardSelector
//
//  Created by projas on 6/29/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import LKAlertController
import AlamofireImage


class ProfileViewController: UIViewController {

  let sessionManager = SessionManager()
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  
  @IBOutlet weak var signOutButton: UIButton!
  let user = CCUserViewModel.getLoggedUser()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userNameLabel.text = "\(user!.firstName) \(user!.lastName)"
    emailLabel.text = user!.email
    
    profileImageView.af_setImageWithURL(NSURL(string: user!.imageUrl)! )
    
    profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    profileImageView.layer.masksToBounds = true
    
    profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
    profileImageView.layer.borderWidth = 5.0
    
    signOutButton.layer.cornerRadius = 5
    signOutButton.clipsToBounds = true
    
  }
  
  
  @IBAction func signOut(sender: AnyObject) {
    ActionSheet()
      .addAction("Cancel")
      .addAction("Sign Out", style: .Default, handler: { _  in
        SessionManager.logOut()
      }).show()
    
    
  }

}
