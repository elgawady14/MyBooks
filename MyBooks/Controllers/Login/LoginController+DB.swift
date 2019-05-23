//
//  LoginController+DB.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 21/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import CoreImage

extension LoginController {
    
    func checkoutUser(_ email: String) {
        
        guard !newUserSwitch.isOn else {
            createUser(self.emailTF.text!, self.passwordTF.text!)
            return
        }
        guard let user = databaseHandler.retrieveUser(email) else {
            indicator?.stopAnimating()
            self.showMessage(title: "⚠️", msg: "Either email or password is wrong!")
            return
        }
        indicator?.stopAnimating()
        userDefaultsHandler.setUserEmail(user.email)
        performSegue(withIdentifier: Constants.StoryBoardKeys.homeSegue, sender: nil)
    }
    
    func createUser(_ email: String, _ password: String) {
        
        do {
            try self.databaseHandler.insertNewUser(email: self.emailTF.text!, password: self.passwordTF.text!)
            indicator?.stopAnimating()
            self.userDefaultsHandler.setUserEmail(email)
            self.performSegue(withIdentifier: Constants.StoryBoardKeys.homeSegue, sender: nil)
        } catch let error as NSError {
            indicator?.stopAnimating()
            self.showMessage(title: "⚠️", msg: error.localizedDescription)
        }
    }
}
