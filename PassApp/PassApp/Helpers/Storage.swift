//
//  Storage.swift
//  PassApp
//
//  Created by cidr5 on 4/21/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

class Storage {
    private var passKeeper: PassKeeper
    
    init() {
        passKeeper = PassKeeper()
        loadPasswords()
    }
    
    func getPasswords() -> [PassData] {
        return passKeeper.getPasswords()
    }
    
    func loadPasswords() {
        if let data = UserDefaults.standard.value(forKey: Config.passwordsArrayKey) as? Data {
            let passwords = try? PropertyListDecoder().decode(Array<PassData>.self, from: data)
            passKeeper.setPasswords(passwords ?? [])
        }
    }
    
    func setPasswords(_ passArray: [PassData]) {
        passKeeper.setPasswords(passArray)
    }
    
    func savePass(_ pass: PassData) {
        passKeeper.addPass(pass)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(passKeeper.getPasswords()), forKey: Config.passwordsArrayKey)
    }
    
    func getPass(_ index: Int) -> PassData? {
        let passwords = passKeeper.getPasswords()
        
        return (passwords.count > index) ? passwords[index] : nil
    }
    
    func deletePass(_ index: Int) {
        if (passKeeper.delete(index)) {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(passKeeper.getPasswords()), forKey: Config.passwordsArrayKey)
        }
    }
}
