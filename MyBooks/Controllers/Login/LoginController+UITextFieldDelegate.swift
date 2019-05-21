//
//  LoginController+UITextFieldDelegate.swift
//  Ego
//
//  Created by Ahmad Abduljawad on 14/03/2019.
//  Copyright © 2019 Ego For Information Technology. All rights reserved.
//

import UIKit

extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
