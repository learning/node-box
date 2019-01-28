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
    @IBOutlet weak var listContainer: NSScrollView!
    
    fileprivate let ConfigFile: [String: String] = [
        "sh": ".profile",
        "bash": ".bashrc",
//        "csh": ".cshrc",
        "fish": ".config/fish/config.fish",
//        "tcsh": ".tcshrc",
        "zsh": ".zshrc"
    ]

    fileprivate enum CellIdentifiers {
        static let VersionCell = "VERSION_CELL"
        static let DateCell = "DATE_CELL"
        static let NpmCell = "NPM_CELL"
        static let ActionCell = "ACTION_CELL"
    }

    var store: Store?;
    var currentList: Array<Version>?;

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reload(notification:)), name: Notification.Name("reload-list"), object: nil)
        self.initStore()
    }
    
    /**
     * Prepare the store for download list
     */
    func initStore() {
        self.store = Store.getStore()
        self.reload(notification: nil)
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
            text = item.npmVersion
            identifier = CellIdentifiers.NpmCell
        } else if tableColumn == tableView.tableColumns[3] {
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
                    version.isActive = false
                    changeVersion(version: nil)
                } else {
                    currentList?.forEach { ver in
                        ver.isActive = (ver === version)
                    }
                    changeVersion(version: version)
                }
                print()
                self.versionView.reloadData()
            }
        } else {
            print("no row clicked")
        }
    }
    
    func changeVersion (version: Version?) {
        let shell = String(ProcessInfo.processInfo.environment["SHELL"]?.split(separator: "/").last ?? "bash")
//        let home = ProcessInfo.processInfo.environment["HOME"]

        _ = Utils.run("rm", "current")
        if version != nil {
            _ = Utils.run("ln", "-s", version!.filename, "current")
        }
        
        if let config = ConfigFile[shell] {
            var export: String?
            if version != nil {
                export = "export PATH=\"\(Utils.directory!.path)/\(version!.filename)/bin:$PATH\""
            } else {
                export = nil
            }
            
            let file = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(config)
            //reading
            do {
                let originalText = try String(contentsOf: file, encoding: .utf8)
                var targetLines = originalText.split(separator: "\n").filter { !$0.contains(Utils.directory!.path) }.map { String($0) }
                if export != nil {
                    targetLines.append(export!)
                }
                let targetText = targetLines.joined(separator: "\n")
                try targetText.write(to: file, atomically: false, encoding: .utf8)
            }
            catch {
                NotificationCenter.default.post(name: Notification.Name("alert"), object: "Error: fail to modify \(file)")
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name("alert"), object: "Error: \"\(shell)\" is not supported.")
        }
    }
    
    /* ---------- Reload ---------- */
    @objc func reload(notification: Notification?) {
        self.currentList = self.store?.versions.filter { $0.isDownloaded }
        if (self.currentList?.count)! > 0 {
            self.versionView.reloadData()
            self.listContainer.isHidden = false
            self.emptyBox.isHidden = true
        } else {
            self.listContainer.isHidden = true
            self.emptyBox.isHidden = false
        }
    }
}
