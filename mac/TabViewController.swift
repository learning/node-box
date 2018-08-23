//
//  ViewController.swift
//  node-box
//
//  Created by Learning on 2018/8/23.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

class TabViewController: NSViewController {

    @IBOutlet weak var versionView: NSView!
    @IBOutlet weak var downloadView: NSView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeTab(notification:)), name: Notification.Name("change-tab"), object: nil)
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @objc func changeTab(notification: NSNotification) {
        switch (notification.object as! Int) {
            case 0:
                versionView.isHidden = false
                downloadView.isHidden = true
                break
            case 1:
                versionView.isHidden = true
                downloadView.isHidden = false
                break
            default:
                NSLog("Not supported action")
                break
        }
    }

}

