//
//  ReviewCategoryTableViewCell.swift
//  QuarantineApp
//
//  Created by iosdev on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class ReviewCategoryTableViewCell: UITableViewCell {
  /Users/iosdev/IosApps/wtf2/quarantineapp/QuarantineApp/Controller/CovidData.swift  //MARK: Properties
    
    @IBOutlet weak var reviewCategoryTitle: UILabel!
    @IBOutlet weak var reviewCategoryImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
