//
//  CommunityGroupTableViewCell.swift
//  QuarantineApp
//
//  Created by iosdev on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

//Defines the community groups tableview cell
class CommunityGroupTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var communityGroupTitle: UILabel!
    @IBOutlet weak var communityGroupImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
