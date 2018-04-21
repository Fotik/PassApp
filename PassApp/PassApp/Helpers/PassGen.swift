//
//  PassGen.swift
//  PassApp
//
//  Created by cidr5 on 4/17/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

class PassGen {
    private let abc = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.![]()";
    
    func generate() -> String {
        return getRandomString(Config.initPassLength + Int(arc4random_uniform(UInt32(Config.passLenRange - 1))))
    }
    
    private func getRandomString(_ len: Int) -> String {
        let abcLen = UInt32(abc.count)
        var randomString = ""
        
        for _ in 0...len {
            randomString.append(abc[abc.index(abc.startIndex, offsetBy: Int(arc4random_uniform(abcLen)))])
        }
        
        return randomString
    }
}
