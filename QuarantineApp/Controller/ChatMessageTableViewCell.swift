//
//  ChatMessageTableViewCell.swift
//  QuarantineApp
//
//  Created by iosdev on 4.5.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chatMessageLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
