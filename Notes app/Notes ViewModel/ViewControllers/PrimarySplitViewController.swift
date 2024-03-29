//
//  PrimarySplitViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 04.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import UIKit
class PrimarySplitViewController: UISplitViewController,
                                  UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }

        // MARK: - Split view
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController:UIViewController,
        onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController =
            secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController =
            secondaryAsNavController.topViewController as? NoteDetailViewController else { return false }
        if topAsDetailController.detailItem == nil { return true }
        return false
    }
}
