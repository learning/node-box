//
//  ViewController.swift
//  node-box
//
//  Created by Learning on 2018/8/23.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

class TabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitionOptions = NSViewController.TransitionOptions(rawValue: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeTab(notification:)), name: Notification.Name("change-tab"), object: nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @objc func changeTab(notification: NSNotification) {
        self.tabView.selectTabViewItem(at: notification.object as! Int)
    }

}

