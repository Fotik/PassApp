//
//  PassKeeper.swift
//  PassApp
//
//  Created by cidr5 on 4/23/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

class PassKeeper {
    private var passwords: [PassData] = []
    
    init() {}
    
    init(_ passwords: [PassData]) {
        self.passwords = passwords
    }
    
    func getPasswords() -> [PassData] {
        return passwords
    }
    
    func setPasswords(_ passArray: [PassData]) {
        passwords = passArray
    }
    
    func addPass(_ pass: PassData) {
        passwords.append(pass)
    }
    
    func update(_ index: Int, _ data: PassData) -> Bool {
        if (passwords.count > index) {
            passwords[index] = data
            return true
        } else {
            return false
        }
    }
    
    func delete(_ index: Int) -> Bool {
        if (passwords.count > index) {
            passwords.remove(at: index)
            return true
        } else {
            return false
        }
    }
}
