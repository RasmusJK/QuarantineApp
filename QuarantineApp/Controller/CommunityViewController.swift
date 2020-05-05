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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = communitytitle
        communityInfoLabel.text = communityInfoText
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
