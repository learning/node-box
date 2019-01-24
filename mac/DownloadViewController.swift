//
//  DownloadViewController.swift
//  node-box
//
//  Created by Learning on 2018/8/27.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

let rootElement: String = "VERSION SERIES"

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
    
    var store: Store?;
    var currentList: Array<Version>?;

    override func viewDidLoad() {
        super.viewDidLoad()
        sidebarView.expandItem(rootElement)
        self.initStore()
    }
    
    /**
     * Prepare the downloadable version list for the app
     */
    func initStore() {
        Store.getStore { (s) -> Void in
            self.store = s
            self.sidebarView.reloadData()
            self.sidebarView.selectRowIndexes(IndexSet(integer: 1), byExtendingSelection: false)
        }
    }
    
    /**
     * Update downloadable version list when sidebar item cliked
     */
    func updateList() {
        let branch = self.store?.branches[sidebarView.selectedRow - 1]
        let pattern:String = branch?.pattern ?? ""
        currentList = self.store?.versions.filter { $0.version.starts(with: pattern) }
        tableView.reloadData()
    }
    
    /* ---------- Sidebar ---------- */

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return 1
        }
        return self.store?.branches.count ?? 0
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
            return self.store?.branches[index].name ?? ""
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let view: NSTableCellView = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("DataCell"), owner: self) as! NSTableCellView

        if let textField = view.textField {
            textField.stringValue = item as! String
        }
        view.imageView?.image = nil

        return view
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        updateList()
    }
    
    /* ---------- Table ---------- */
    func numberOfRows(in tableView: NSTableView) -> Int {
        return currentList?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = "";
        var identifier: String = "";

        // Get an item from list
        guard let item:Version = currentList?[row] else {
            return nil
        }
        

        if tableColumn == tableView.tableColumns[0] {
            text = item.version
            identifier = CellIdentifiers.VersionCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.date
            identifier = CellIdentifiers.DateCell
        } else if tableColumn == tableView.tableColumns[2] {
            
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }

        return nil
    }
}
