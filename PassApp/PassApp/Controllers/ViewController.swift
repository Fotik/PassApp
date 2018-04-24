//
//  ViewController.swift
//  PassApp
//
//  Created by cidr5 on 4/14/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var passTable: UITableView!
    
    let tableHandler = PassTableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passTable.delegate = tableHandler
        passTable.dataSource = tableHandler
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        passTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

