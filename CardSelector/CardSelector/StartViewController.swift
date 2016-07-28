//
//  StartViewController.swift
//  CardSelector
//
//  Created by projas on 7/27/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      //Choose the right storyboard to start depending if user is logged or not
      NavigationManager.setInitialStoryboard()
    }

}
