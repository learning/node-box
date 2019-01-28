//
//  AppDelegate.swift
//  node-box
//
//  Created by Learning on 2018/8/23.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (!flag) {
            NotificationCenter.default.post(name: Notification.Name("reopen"), object: nil)
        }
        return true
    }

    @IBAction func help(_ sender: Any) {
        NSWorkspace.shared.open(URL.init(string: "https://github.com/learning/node-box")!)
    }

}

