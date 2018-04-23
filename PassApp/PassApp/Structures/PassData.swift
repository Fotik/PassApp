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
    
    init(resource: String, password: String, interval: Date?, time: Date?) {
        self.resource = resource
        self.password = password
        self.notificationInterval = interval ?? nil
        self.notificationTime = time ?? nil
    }
    
    init(coder decoder: NSCoder) {
        let resource = decoder.decodeObject(forKey: "resource") as? String ?? ""
        let password = decoder.decodeObject(forKey: "password") as? String ?? ""
        let notificationInterval = decoder.decodeObject(forKey: "notificationInterval") as? Date ?? nil
        let notificationTime = decoder.decodeObject(forKey: "notificationTime") as? Date ?? nil
        
        self.init(resource: resource, password: password, interval: notificationInterval, time: notificationTime)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(resource, forKey: "resource")
        coder.encode(password, forKey: "password")
        coder.encode(notificationInterval, forKey: "notificationInterval")
        coder.encode(notificationTime, forKey: "notificationTime")
    }
}
