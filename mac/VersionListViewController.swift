//
//  VersionListViewController.swift
//  node-box
//
//  Created by Learning on 2018/8/29.
//  Copyright © 2018 Learning. All rights reserved.
//

import Cocoa

class VersionListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var emptyBox: NSBox!
    @IBOutlet weak var versionView: NSTableView!

    fileprivate enum CellIdentifiers {
        static let VersionCell = "VERSION_CELL"
        static let DateCell = "DATE_CELL"
        static let ActionCell = "ACTION_CELL"
    }

    var store: Store?;
    var currentList: Array<Version>?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initStore()
    }
    
    /**
     * Prepare the store for download list
     */
    func initStore() {
        Store.getStore { (s) -> Void in
            self.store = s
            self.currentList = self.store?.versions.filter { $0.isDownloaded }
            self.versionView.reloadData()
        }
    }

    @IBAction func download(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("change-tab"), object: 1)
    }
    
    /* ---------- List ---------- */
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
            if item.isActive {
                text = "✅"
            } else {
                text = ""
            }
            identifier = CellIdentifiers.ActionCell
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
    
    @IBAction func doubleClick(_ sender: NSTableView) {
        if sender.clickedRow > -1 {
            if let version = currentList?[ sender.clickedRow ] {
                if version.isActive {
                    print("no action")
                } else {
                    currentList?.forEach { ver in
                        ver.isActive = (ver === version)
                    }
                    _ = Utils.run("rm", "current")
                    _ = Utils.run("ln", "-s", version.filename, "current")
                    self.versionView.reloadData()
                }
            }
        } else {
            print("no row clicked")
        }
    }
}
