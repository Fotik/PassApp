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
        passKeeper.setPasswords(NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: Config.passwordsArrayKey) as? Data ?? Data()) as? [PassData] ?? [])
        
        return passKeeper.getPasswords() ?? []
    }
    
    func setPasswords(_ passArray: [PassData]) {
        passKeeper.setPasswords(passArray)
    }
    
    func savePass(_ pass: PassData) {
        passKeeper.addPass(pass)
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: passKeeper), forKey: Config.passwordsArrayKey)
    }
}
