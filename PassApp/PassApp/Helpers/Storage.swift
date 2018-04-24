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
    }
    
    func getPasswords() -> [PassData] {
        return passKeeper.getPasswords() ?? loadPasswords()
    }
    
    func loadPasswords() -> [PassData] {
        if let data = UserDefaults.standard.value(forKey: Config.passwordsArrayKey) as? Data {
            let passwords = try? PropertyListDecoder().decode(Array<PassData>.self, from: data)
            passKeeper.setPasswords(passwords ?? [])
        }
        
        return passKeeper.getPasswords() ?? []
    }
    
    func setPasswords(_ passArray: [PassData]) {
        passKeeper.setPasswords(passArray)
    }
    
    func savePass(_ pass: PassData) {
        var newPass = pass;
        let lastPass = passKeeper.getPasswords()?.last
        newPass.id = (lastPass != nil) ? lastPass!.id + 1 : 1
        passKeeper.addPass(newPass)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(passKeeper.getPasswords()), forKey: Config.passwordsArrayKey)
    }
}
