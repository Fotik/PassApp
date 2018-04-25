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
        tableHandler.superController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        passTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let target = segue.destination as? PassEditViewController else {return}
        guard let button = sender as? UIButton else {return}
        guard let cell = button.superview?.superview as? PassTableViewCell else {return}
        
        if segue.identifier! == "passEditSegue" {
            if cell.passIndex != nil {
                target.passIndex = cell.passIndex!
            }
        }
    }

}

