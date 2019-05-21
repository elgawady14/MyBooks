//
//  UserDefaultsHandler.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 21/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import Foundation
class UserDefaultsHandler: NSObject {
    
    static let shared = UserDefaultsHandler()
    private var userEmail: String?
}

extension UserDefaultsHandler {
    
    func setUserEmail(_ userEmail: String?) {
        
        self.userEmail = userEmail
        guard let _ = userEmail else {
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKeys.USER_Email)
            return
        }
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: userEmail!), forKey: Constants.UserDefaultsKeys.USER_Email)
    }
    
    func getUserEmail() -> String? {
        
        guard let _ = userEmail else {
            guard let data = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.USER_Email) as? Data else {
                return nil
            }
            userEmail = NSKeyedUnarchiver.unarchiveObject(with: data) as? String
            return userEmail
        }
        return userEmail
    }
    
    func isUserLoggedIn() -> Bool {
        return getUserEmail() != nil
    }
    
}
