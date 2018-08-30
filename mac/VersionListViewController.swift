//
//  VersionListViewController.swift
//  node-box
//
//  Created by Learning on 2018/8/29.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

class VersionListViewController: NSViewController {

    @IBOutlet weak var emptyBox: NSBox!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    @IBAction func download(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("change-tab"), object: 1)
    }
    
}
