//
//  PassKeeper.swift
//  PassApp
//
//  Created by cidr5 on 4/23/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

class PassKeeper {
    private var passwords: [PassData]?
    
    init() {}
    
    init(_ passwords: [PassData]) {
        self.passwords = passwords
    }
    
    func getPasswords() -> [PassData]? {
        return passwords ?? nil
    }
    
    func setPasswords(_ passArray: [PassData]) {
        passwords = passArray
    }
    
    func addPass(_ pass: PassData) {
        if passwords != nil {
            passwords!.append(pass)
        } else {
            passwords = [pass]
        }
    }
    
    func getPass(_ index: Int) -> PassData? {
        guard passwords != nil else  {return nil}
        
        return passwords!.count > index ? passwords![index] : nil
    }
    
    func update(_ index: Int, _ data: PassData) -> Bool {
        guard passwords != nil else  {return false}
        
        if passwords!.count > index {
            passwords![index] = data
            return true
        } else {
            return false
        }
    }
    
    func delete(_ index: Int) -> Bool {
        guard passwords != nil else  {return false}
        
        if passwords!.count > index {
            passwords!.remove(at: index)
            return true
        } else {
            return false
        }
    }
}
