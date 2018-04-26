//
//  PassTableDataSource.swift
//  PassApp
//
//  Created by cidr5 on 4/24/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class PassTableDataSource: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let storage = Singleton.storage
    let passCellIdentifier = "PassCell"
    var superController: UIViewController?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.getPasswords().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: passCellIdentifier) as! PassTableViewCell
        let pass = storage.getPass(indexPath.row)
        if (pass != nil) {
            cell.passIndex = indexPath.row
            cell.resourceLabel.text = pass!.resource
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let confirmAlert = UIAlertController(title: "Are you sure?", message: "Thiss password will be permanently lost!", preferredStyle: .alert)
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            guard let pass = self.storage.getPass(indexPath.row) else {return}
            
            if pass.notificationIdentifier != nil {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(Config.alertPrefix)\(pass.notificationIdentifier!)"])
            }
            self.storage.deletePass(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }))
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {action in
            confirmAlert.dismiss(animated: true, completion: nil)
        }))
        
        superController?.present(confirmAlert, animated: true, completion: nil)
    }
}
