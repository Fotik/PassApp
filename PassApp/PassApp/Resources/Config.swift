//
//  Config.swift
//  PassApp
//
//  Created by cidr5 on 4/19/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

struct Config {
    // Notification params
    static let notificationIntervals = [
        604800, //s (1 week)
        1209600, //s (2 weeks)
        2592000 //s (30 days)
    ]
    
    // PassGen params
    static let initPassLength = 8
    static let passLenRange = 5
    
    // Storage Params
    static let passwordsArrayKey = "passwords"
}
