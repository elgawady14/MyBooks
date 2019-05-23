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
    
    func checkoutUser() {
        
        guard !newUserSwitch.isOn else {
            createUser(self.emailTF.text!, self.passwordTF.text!)
            return
        }
        do {
            
            let user = try databaseHandler.login(email: emailTF.text!, password: passwordTF.text!)
            indicator?.stopAnimating()
            userDefaultsHandler.setUserEmail(user.email)
            performSegue(withIdentifier: Constants.StoryBoardKeys.homeSegue, sender: nil)
            
        } catch let error as NSError {
            indicator?.stopAnimating()
            self.showMessage(title: "⚠️", msg: error.localizedDescription)
        }
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
