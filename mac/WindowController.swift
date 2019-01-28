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
    @IBOutlet weak var tabControl: NSSegmentedControl!
    @IBOutlet weak var refreshButton: NSButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reopen(notification:)), name: Notification.Name("reopen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLoading(notification:)), name: Notification.Name("show-loading"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setLoading(notification:)), name: Notification.Name("hide-loading"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeTab(notification:)), name: Notification.Name("change-tab"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.alert(notification:)), name: Notification.Name("alert"), object: nil)

        var frame = self.window?.frame
        frame?.size = NSSize(width: 620, height: 350)
        refreshButton.isHidden = true
        self.window?.setFrame(frame!, display: true)
    }

    @IBAction func tabAction(_ sender: NSSegmentedControl) {
        NotificationCenter.default.post(name: NSNotification.Name("change-tab"), object: sender.selectedSegment)
    }
    
    @objc func changeTab(notification: Notification) {
        tabControl.setSelected(true, forSegment: notification.object as! Int)
        refreshButton.isHidden = (notification.object as! Int == 0)
    }
    
    @objc func reopen(notification: Notification) {
        self.window?.makeKeyAndOrderFront(nil)
    }
    
    @objc func setLoading(notification: Notification) {
        if notification.name.rawValue == "show-loading" {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimation(self)
            self.refreshButton.isEnabled = false
        } else {
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimation(self)
            self.refreshButton.isEnabled = true
        }
    }
    
    @objc func alert(notification: Notification) {
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.messageText = "Error"
        alert.informativeText = notification.object as! String
        alert.alertStyle = NSAlert.Style.critical
        
        alert.beginSheetModal(for: self.window!, completionHandler: {(response) -> Void in
            print(response)
        })
    }

    @IBAction func refresh(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("refresh-list"), object: nil)
    }
}
