//
//  EmailSessionManager.swift
//  CardSelector
//
//  Created by projas on 7/3/16.
//  Copyright © 2016 ABC. All rights reserved.
//



class EmailSessionManager: SessionTestManager {
  static func signIn() {
    CCUserViewModel.saveUserIntoReal(CCUser(WithEmail: "projas@nearsoft.com"))
    NavigationManager.goMain()
  }
  
  static func signOut() {
    CCUserViewModel.deleteLoggedUser()
    NavigationManager.goLogin()
  }
  
  

}
