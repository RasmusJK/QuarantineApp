//
//  TopItemTableViewCell.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class TopItemTableViewCell: UITableViewCell {
    @IBOutlet var Thumbnail: UIImageView!
    @IBOutlet var Title: UILabel!
    @IBOutlet var Users: UILabel!
    @IBOutlet var Available: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
