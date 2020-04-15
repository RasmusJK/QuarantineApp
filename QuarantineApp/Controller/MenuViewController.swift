//
//  MenuViewController.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 15.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

enum menuItem: Int {
    case profile
    case tracker
    case help
    case logout
}

class MenuViewController: UITableViewController {
    
    var didTapMenuItem: ((menuItem) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuItem = menuItem(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            print("Dismissing menu: \(menuItem)")
            self?.didTapMenuItem?(menuItem)
        }
    }
}
