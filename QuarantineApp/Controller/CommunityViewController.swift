//
//  CommunityViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 14.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {
    //MARK: Properties
    @IBOutlet var menuButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var communityInfoLabel: UILabel!
    
    var communitytitle = NSLocalizedString("The community is here!", comment: "")
    var communityInfoText = NSLocalizedString("See what other users are recommending and share your own reviews of things to do online!", comment: "")
    
    //Sets the localized strings to text labels
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = communitytitle
        communityInfoLabel.text = communityInfoText
        
    }
}
