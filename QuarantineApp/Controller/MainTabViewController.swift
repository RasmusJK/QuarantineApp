//
//  MainTabViewController.swift
//  QuarantineApp
//
//  Created by Topias Peiponen on 15.4.2020.
//  Copyright © 2020 Roope Vaarama. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    //MARK: Properties
    let transition = SlideInTransition()
    var menuIsActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
        Shows and dismisses the side/burger menu
     */
    @IBAction func menuPressed(_ sender: UIButton) {
        if !menuIsActive {
            guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
            menuViewController.didTapMenuItem = { menuItem in
                print(menuItem)
                // self.changeView(menuItem)
            }
            menuViewController.modalPresentationStyle = .overCurrentContext
            menuViewController.transitioningDelegate = self
            menuIsActive = true
            present(menuViewController, animated: true)
        } else {
            menuIsActive = false
            dismiss(animated: true, completion: {
                print("Dismissing menu")
            })
        }
    }
    func changeView(_ menuItem: menuItem)  {
        switch menuItem {
        case .profile:
            present(((storyboard?.instantiateViewController(withIdentifier: "Profile"))!), animated: true)
        case .tracker:
            present(((storyboard?.instantiateViewController(withIdentifier: "CovidTracker"))!), animated: true)
        case .help:
            print("ASD")
        case .logout:
            print("asd")
        }
    }
}

extension MainTabViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isActive = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isActive = false
        return transition
    }
}
