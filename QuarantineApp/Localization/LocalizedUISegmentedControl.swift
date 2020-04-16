//
//  LocalizedUISegmentedControl.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 16.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

/**
    Localizes the titles in a segmented bar control
 */
class LocalizedUISegmentedControl: UISegmentedControl {
    override func awakeFromNib() {
        for i in 0...(numberOfSegments-1) {
            self.setTitle(NSLocalizedString(titleForSegment(at: i)!, comment: ""), forSegmentAt: i)
        }
    }

}
