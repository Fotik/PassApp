//
//  PassTableViewCell.swift
//  PassApp
//
//  Created by cidr5 on 4/25/18.
//  Copyright © 2018 cidr5. All rights reserved.
//

import UIKit

class PassTableViewCell: UITableViewCell {

    @IBOutlet weak var resourceLabel: UILabel!
    
    var passIndex: Int?
    private let storage = Singleton.storage
    
    @IBAction func copyPass(_ sender: UIButton) {
        if passIndex != nil {
            UIPasteboard.general.string = storage.getPass(passIndex!)?.password
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
