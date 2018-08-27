//
//  DownloadViewController.swift
//  node-box
//
//  Created by Learning on 2018/8/27.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

let items: [String] = ["All", "Node.js 10.x", "Node.js 9.x", "Node.js 8.x", "Node.js 6.x", "Node.js 4.x", "Node.js 0.12.x", "Node.js 0.10.x"]

class DownloadViewController: NSSplitViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {

    @IBOutlet weak var sidebarView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        NSLog("Download View Did Load")
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return items.count
        }
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return items[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let view: NSTableCellView = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("DataCell"), owner: self) as! NSTableCellView

        if let textField = view.textField {
            textField.stringValue = item as! String
        }
        view.imageView?.image = nil
//        if let image = account.icon {
//            view.imageView!.image = image
//        }
        return view
    }
}
