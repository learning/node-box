//
//  WindowController.swift
//  node-box
//
//  Created by Learning on 2018/8/23.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    var center:NotificationCenter = NotificationCenter.default

    override func windowDidLoad() {
        super.windowDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reopen(notification:)), name: Notification.Name("reopen"), object: nil)
    }

    @IBAction func tabAction(_ sender: NSSegmentedControl) {
        NotificationCenter.default.post(name: NSNotification.Name("change-tab"), object: sender.selectedSegment)
    }
    
    @objc func reopen(notification: Notification) {
        self.window?.makeKeyAndOrderFront(nil)
    }
}
