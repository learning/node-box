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

class DownloadViewController: NSSplitViewController,
                              NSOutlineViewDelegate,
                              NSOutlineViewDataSource,
                              NSTableViewDelegate,
                              NSTableViewDataSource {
    
    @IBOutlet weak var sidebarView: NSOutlineView!
    @IBOutlet weak var tableView: NSTableView!
    
    fileprivate enum CellIdentifiers {
        static let VersionCell = "VERSION_CELL"
        static let DateCell = "DATE_CELL"
    }
    
    var versions: Array<Dictionary<String, Any>>?;
    var branches: Array<Dictionary<String, Any>>?;
    var currentList: Array<Dictionary<String, Any>>?;

    override func viewDidLoad() {
        super.viewDidLoad()
        sidebarView.expandItem(rootElement)
        sidebarView.selectRowIndexes(IndexSet(integer: 1), byExtendingSelection: false)
        self.initData()
    }
    
    /**
     * Prepare the downloadable version list for the app
     */
    func initData() {
        let data = VersionManager.getData()
        if data != nil {
            print("already exists")
            versions = data!["versions"]
            branches = data!["branches"]
            tableView.reloadData()
        } else {
            print("not exists, downloading...")
            VersionManager.updateDownloadList {
                self.initData()
            }
        }
    }
    
    /* ---------- Sidebar ---------- */

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
    
    /* ---------- Table ---------- */
    func numberOfRows(in tableView: NSTableView) -> Int {
        return versions?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = "";
        var identifier: String = "";

        // Get an item from list
        guard let item:Dictionary<String, Any> = versions?[row] else {
            return nil
        }
        

        if tableColumn == tableView.tableColumns[0] {
            text = item["version"] as! String
            identifier = CellIdentifiers.VersionCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item["date"] as! String
            identifier = CellIdentifiers.DateCell
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }

        return nil
    }
}
