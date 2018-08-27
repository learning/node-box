//
//  WindowController.swift
//  node-box
//
//  Created by Learning on 2018/8/23.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    var center:NotificationCenter = NotificationCenter.default

    override func windowDidLoad() {
        super.windowDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reopen(notification:)), name: Notification.Name("reopen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLoading(notification:)), name: Notification.Name("show-loading"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLoading(notification:)), name: Notification.Name("hide-loading"), object: nil)
        var frame = self.window?.frame
        frame?.size = NSSize(width: 480, height: 270)
        self.window?.setFrame(frame!, display: true)
        let downloadList: Array<Dictionary<String, Any>>? = VersionManager.getDownloadList()
    }

    @IBAction func tabAction(_ sender: NSSegmentedControl) {
        NotificationCenter.default.post(name: NSNotification.Name("change-tab"), object: sender.selectedSegment)
    }
    
    @objc func reopen(notification: Notification) {
        self.window?.makeKeyAndOrderFront(nil)
    }
    
    @objc func setLoading(notification: Notification) {
        if notification.name.rawValue == "show-loading" {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimation(self)
        } else {
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimation(self)
        }
    }
}
