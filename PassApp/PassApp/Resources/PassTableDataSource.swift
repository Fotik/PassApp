//
//  PassTableDataSource.swift
//  PassApp
//
//  Created by cidr5 on 4/24/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import Foundation
import UIKit

class PassTableDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    let storage = Singleton.storage
    let passCellIdentifier = "PassCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.getPasswords().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: passCellIdentifier)!
        let pass = storage.getPass(indexPath.row)
        if (pass != nil) {
            cell.textLabel?.text = pass!.resource
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        storage.deletePass(indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
