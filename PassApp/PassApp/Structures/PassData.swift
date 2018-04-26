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
    var resource: String = ""
    var password: String = ""
    var intervalSegment: UInt8?
    var notificationTime: Date?
    var notificationCountPoint: Date?
    var notificationIdentifier: UInt?
    
    init(_ resource: String, _ password: String) {
        set(resource, password, nil, nil)
    }
    
    init(_ resource: String, _ password: String, _ segment: UInt8, _ time: Date) {
        set(resource, password, segment, time)
    }
    
    mutating func set(_ resource: String, _ password: String, _ segment: UInt8?, _ time: Date?) {
        self.resource = resource
        self.password = password
        self.intervalSegment = segment
        self.notificationTime = time
        if segment != nil && time != nil {
            self.notificationCountPoint = Date()
        }
    }
    
    mutating func removeNotificationData() {
        self.intervalSegment = nil
        self.notificationTime = nil
        self.notificationCountPoint = nil
    }
}
