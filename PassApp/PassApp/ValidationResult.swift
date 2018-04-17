//
//  ValidationResult.swift
//  PassApp
//
//  Created by cidr5 on 4/17/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

enum ValidationResultType: Int {
    case ok = 0
    case error = 1
}

struct ValidationResult {
    var type: ValidationResultType
    var message: String
    
    init(type: ValidationResultType, message: String) {
        self.type = type
        self.message = message
    }
}
