//
//  AppDelegate.swift
//  CardSelector
//
//  Created by projas on 6/26/16.
//  Copyright © 2016 ABC. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleMaps

import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    //To use google maps
    GMSServices.provideAPIKey("AIzaSyDYrHJV4WhpDjueEZLSPzkrrk8jaDrn7e4")
    
    Fabric.with([Crashlytics.self])

    
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected)
    
    //Initialize Facebook Sign-in
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    
    Answers.logCustomEventWithName("App was opened", customAttributes: ["time": NSDate().stringFromFormat("dd/MMM/yyyy h:mm a")])
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  //Deprecated. Only for iOS 8 and before
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    return SessionManager.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
  }
  
  
  func application(application: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
    return SessionManager.application(application, openURL: url, options: options)
  }
  
}

