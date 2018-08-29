//
//  DownloadViewController.swift
//  node-box
//
//  Created by Learning on 2018/8/27.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

let rootElement: String = "VERSION SERIES"
let items: [String] = ["All", "Node.js 10.x", "Node.js 9.x", "Node.js 8.x", "Node.js 6.x", "Node.js 4.x", "Node.js 0.12.x", "Node.js 0.10.x"]

class DownloadViewController: NSSplitViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    @IBOutlet weak var sidebarView: NSOutlineView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sidebarView.expandItem(rootElement)
        sidebarView.selectRowIndexes(IndexSet(integer: 1), byExtendingSelection: false)
        VersionManager.updateDownloadList()
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return 1
        }
        return items.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return item as! String == rootElement
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return item as! String == rootElement
    }

    func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
        return item as! String == rootElement
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldCollapseItem item: Any) -> Bool {
        return item as! String != rootElement
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        return item as! String != rootElement
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            // root element
            return rootElement
        } else {
            return items[index]
        }
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
