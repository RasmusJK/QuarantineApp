//
//  LocalizedUILabel.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 15.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

/**
    This class localizes the text in UI labels. Apply this to every UI label element that is to be localized
 */
class LocalizedUILabel: UILabel {
    override func awakeFromNib() {
        if let text = text {
            self.text = NSLocalizedString(text, comment: "")
        }
    }
}
