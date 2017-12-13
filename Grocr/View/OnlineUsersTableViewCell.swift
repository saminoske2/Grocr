//
//  OnlineUsersTableViewCell.swift
//  Grocr
//
//  Created by Quinton Quaye on 12/11/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class OnlineUsersTableViewCell: UITableViewCell {
    @IBOutlet weak var userEmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getOnlineUser(user: GrocrUser){
        self.userEmailLabel.text = user.userName
    }

}
