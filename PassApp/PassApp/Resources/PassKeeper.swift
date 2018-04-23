//
//  PassKeeper.swift
//  PassApp
//
//  Created by cidr5 on 4/23/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

class PassKeeper: NSObject, NSCoding {
    private var passwords: [PassData]?
    
    override init() {
        super.init()
    }
    
    init(_ passwords: [PassData]?) {
        self.passwords = passwords
    }
    
    required convenience init(coder decoder: NSCoder) {
        let passwords = decoder.decodeObject(forKey: Config.passwordsArrayKey) as? [PassData] ?? nil
        self.init(passwords)
    }
    
    func getPasswords() -> [PassData]? {
        return passwords ?? nil
    }
    
    func setPasswords(_ passArray: [PassData]) {
        passwords = passArray
    }
    
    func addPass(_ pass: PassData) {
        if (passwords != nil) {
            passwords?.append(pass)
        } else {
            passwords = [pass]
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(passwords, forKey: Config.passwordsArrayKey)
    }
}
