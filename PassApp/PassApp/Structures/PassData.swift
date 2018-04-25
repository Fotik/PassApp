//
//  PassData.swift
//  PassApp
//
//  Created by cidr5 on 4/17/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation
import UserNotifications

struct PassData: Codable {
    var resource: String
    var password: String
    var notificationTime: DateComponents?
    var notificationIdentifier: UNNotificationRequest?
    
    init(_ resource: String, _ password: String) {
        self.resource = resource
        self.password = password
    }
    
    init(_ resource: String, _ password: String, _ time: DateComponents?) {
        self.init(resource, password)
        self.notificationTime = time ?? nil
    }
}
