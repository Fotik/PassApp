//
//  PassData.swift
//  PassApp
//
//  Created by cidr5 on 4/17/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

struct PassData {
    var resource: String
    var password: String
    var notificationInterval: Date? = nil
    var notificationTime: Date? = nil
    
    init(resource: String, password: String) {
        self.resource = resource
        self.password = password
    }
    
    init(resource: String, password: String, interval: Date, time: Date) {
        self.resource = resource
        self.password = password
        self.notificationInterval = interval
        self.notificationTime = time
    }
}
