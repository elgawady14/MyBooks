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
        
        guard let user = databaseHandler.retrieveUser(email) else {
            createUser(self.emailTF.text!, self.passwordTF.text!)
            return
        }
        userDefaultsHandler.setUserEmail(user.email)
        presentHomePage()
    }
    
    func createUser(_ email: String, _ password: String) {
        
        do {
            try self.databaseHandler.insertNewUser(email: self.emailTF.text!, password: self.passwordTF.text!)
            self.showOneActionAlert(title: "👍", msg: "User created successfully!", btnTitle: "Ok", btnHandler: {
                self.userDefaultsHandler.setUserEmail(email)
                self.presentHomePage()
            })
            
        } catch let error as NSError {
            self.showMessage(title: "⚠️", msg: error.description)
        }
    }
}
