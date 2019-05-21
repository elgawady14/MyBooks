//
//  UIViewExtensions.swift
//  Ego
//
//  Created by Ahmad Abduljawad on 3/28/18.
//  Copyright © 2018 Ego. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    static var isFadi: (String?)->Bool = { (str: String?)->Bool in
        
        if str == nil || str!.isFadi {  return true } else { return false }
    }
    
    var isFadi: Bool {
        get {
            if self.trimmingCharacters(in: .whitespaces).isEmpty { return true } else { return false }
        }
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
