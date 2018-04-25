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
    
    func updatePass(_ index: Int, _ data: PassData) {
        if passKeeper.update(index, data) {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(passKeeper.getPasswords()), forKey: Config.passwordsArrayKey)
        }
    }
    
    func getPass(_ index: Int) -> PassData? {
        let passwords = passKeeper.getPasswords()
        
        return (passwords.count > index) ? passwords[index] : nil
    }
    
    func deletePass(_ index: Int) {
        if passKeeper.delete(index) {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(passKeeper.getPasswords()), forKey: Config.passwordsArrayKey)
        }
    }
    
    func getLastPassIndex() -> UInt {
        let index = UserDefaults.standard.value(forKey: Config.lastPassIndexKey) as? UInt
        if index == nil {
            UserDefaults.standard.set(0, forKey: Config.lastPassIndexKey)
            return UInt(0)
        } else {
            return index!
        }
    }
    
    func riseLastPassIndex() {
        let index = UserDefaults.standard.value(forKey: Config.lastPassIndexKey) as? UInt
        
        if index != nil {
            UserDefaults.standard.set(index! + 1, forKey: Config.lastPassIndexKey)
        } else {
            UserDefaults.standard.set(0, forKey: Config.lastPassIndexKey)
        }
    }
}
