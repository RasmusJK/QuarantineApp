//
//  ItemTableViewCell.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet var img: UIImageView!
    @IBOutlet var Title: UILabel!
    @IBOutlet var DescOrDev: UILabel!
    @IBOutlet var Rating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
