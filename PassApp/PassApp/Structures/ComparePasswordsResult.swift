//
//  ComparePasswordsResult.swift
//  PassApp
//
//  Created by cidr5 on 4/26/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

class ComparePasswordsResult {
    var resourceIsEqual = true
    var passwordIsEqual = true
    var notificationIsEqual = true
    var isEqual = true
    
    init(_ resource: Bool, _ password: Bool, _ notification: Bool) {
        self.resourceIsEqual = resource
        self.passwordIsEqual = password
        self.notificationIsEqual = notification
        
        if (!resource || !password || !notification) {
            self.isEqual = false
        }
    }
}
