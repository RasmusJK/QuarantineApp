//
//  UserReviewTableViewCell.swift
//  abseil
//
//  Created by iosdev on 22.4.2020.
//

import UIKit

//This class defines the user review tableview cell
class UserReviewTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var reviewItemTitleLabel: UILabel!
    @IBOutlet weak var reviewerUsernameLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    @IBOutlet weak var ratingTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
