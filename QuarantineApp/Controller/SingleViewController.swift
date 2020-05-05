//
//  SingleViewController.swift
//  QuarantineApp
//
//  Created by iosdev on 4.5.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController {
    //MARK: Properties
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var rating_: UILabel!
    @IBOutlet var descOrDev_: UILabel!
    @IBOutlet var singleTitle_: UILabel!
    var titleText = String()
    var descOrDevText = String()
    var ratingText = String()
    var singleTitleText = String()
    var imgurl = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleTitle_.text = singleTitleText
        descOrDev_.text = descOrDevText
        rating_.text = ratingText
        img.image = imgurl
    }
}
