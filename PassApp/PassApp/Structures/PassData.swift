//
//  PassData.swift
//  PassApp
//
//  Created by cidr5 on 4/17/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation

struct PassData: Codable {
    var id = 0
    var resource: String
    var password: String
    var notificationInterval: Date?
    var notificationTime: Date?
    
    init(_ resource: String, _ password: String) {
        self.resource = resource
        self.password = password
    }
    
    init(_ resource: String, _ password: String, _ interval: Date?, _ time: Date?) {
        self.init(resource, password)
        self.notificationInterval = interval ?? nil
        self.notificationTime = time ?? nil
    }
}
