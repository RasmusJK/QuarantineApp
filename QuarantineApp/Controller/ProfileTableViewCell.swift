//
//  ProfileTableViewCell.swift
//  QuarantineApp
//
//  Created by iosdev on 3.5.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileTitleLabel: UILabel!
    
    @IBOutlet weak var profileTextLabel: UILabel!
    
    @IBOutlet weak var profileRatingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
