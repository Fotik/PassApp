//
//  Storage.swift
//  PassApp
//
//  Created by cidr5 on 4/21/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

class Storage {
    private var passwords: [PassData]?
    
    func getPasswords() -> [PassData] {
        if passwords == nil {
            loadPasswords()
        }
        
        // Passwords must be not nil here !!!
        return passwords!
    }
    
    func loadPasswords() {
        // This method must set the passwords member not nil value
        passwords = UserDefaults.standard.array(forKey: "\(Config.passwordsArrayKey)") as? [PassData] ?? []
    }
    
    func setPasswords(_ passArray: [PassData]) {
        passwords = passArray
    }
    
    func savePass(_ pass: PassData) {
        var passArray = getPasswords()
        passArray.append(pass)
        UserDefaults.standard.set(passArray, forKey: "\(Config.passwordsArrayKey)")
        setPasswords(passArray)
    }
}
