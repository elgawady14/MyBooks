//
//  AddEditController+UITextFieldDelegate.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 22/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

extension AddEditController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
