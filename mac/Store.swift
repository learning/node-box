//
//  VersionManager.swift
//  node-box
//
//  Created by Learning on 2018/8/24.
//  Copyright © 2018 Learning. All rights reserved.
//

import Foundation
import Alamofire

let VERSION_URL = "https://raw.githubusercontent.com/learning/node-box/master/data.json"

class Store {
    static private var store:Store? = nil;
    
    var branches:Array<Branch> = [];
    var versions:Array<Version> = [];
    
    init (data: Dictionary<String, Any>) {
        self.updateWith(data: data)
    }

    func updateWith(data: Dictionary<String, Any>) {
        self.branches = (data["branches"] as! Array<Dictionary<String, String>>).map { Branch(data: $0) }
        self.versions = (data["versions"] as! Array<Dictionary<String, Any>>).map { Version(data: $0) }
        do {
            let files = try FileManager.default.contentsOfDirectory(at: Utils.directory!, includingPropertiesForKeys: nil)
            let dirs = files.filter { $0.hasDirectoryPath }
                .map { $0.path.components(separatedBy: "/").last }
            dirs.forEach { dir in
                versions.first(where: { $0.filename == dir })?.isDownloaded = true
            }
        } catch {
            NotificationCenter.default.post(name: Notification.Name("alert"), object: "Error: list node.js downloaded versions")
        }
        let ver = Utils.runAndGetOutput("readlink", "current")?.trimmingCharacters(in: NSCharacterSet.newlines)
        versions.first(where: { $0.filename == ver })?.isActive = true
    }
    
    static public func getStore(onSuccess success: @escaping (Store) -> Void) {
        if store != nil {
            // Store exists
            success(store!)
        } else {
            // Initialize needed
            var data = getData()
            if data != nil {
                print("file exists.")
                store = Store(data: data!)
                success(store!)
            } else {
                print("file dose not exists, downloading...")
                updateDownloadList {
                    data = getData()
                    if data != nil {
                        store = Store(data: data!)
                        success(store!)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name("alert"), object: "Download error, please try again.")
                    }
                }
            }
        }
    }
    
    public func refresh(onSuccess success: @escaping () -> Void) {
        // TODO: refresh version list
        Store.updateDownloadList {
            let data = Store.getData()
            if data != nil {
                self.updateWith(data: data!)
                success()
            } else {
                NotificationCenter.default.post(name: Notification.Name("alert"), object: "Download error, please try again.")
            }
        }
    }

    /**
     * Get a local file from file system
     *
     * - parameters:
     *   - name: The file's name
     */
    static private func getFile(name: String) -> URL? {
        if let pathComponent = Utils.directory?.appendingPathComponent(name) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return pathComponent
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /**
     * Write plain text to a local file
     *
     * - parameters:
     *   - name: The file's name
     *   - content: Plain text to be written
     */
    static private func writeFile(name: String, content: String) -> Bool {
        // If directory not exists, create it
        if !FileManager.default.fileExists(atPath: (Utils.directory?.path)!) {
            do {
                try FileManager.default.createDirectory(at: Utils.directory!, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("Create directory \(Utils.directory!.path) failed")
                return false
            }
        }
        let file: URL? = Utils.directory?.appendingPathComponent(name)
        if file != nil {
            do {
                try content.write(to: file!, atomically: false, encoding: String.Encoding.utf8)
                return true
            } catch {
                return false
            }
        }
        return false
    }

    /**
     * Get data from *data.json*
     * - **data["branches"]**: All available version branches
     * - **data["versions"]**: All downloadable version list
     */
    static private func getData () -> Dictionary<String, Any>? {
        let file: URL? = getFile(name: "data.json")
        if file != nil {
            let data = try! JSONSerialization.jsonObject(with: Data(contentsOf: file!), options: [])
            return data as? Dictionary<String, Any>
        } else {
            return nil
        }
    }
    
    static private func updateDownloadList (onSuccess success: @escaping () -> Void) {
        Alamofire.request(VERSION_URL).responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // Write json to file
                if writeFile(name: "data.json", content: utf8Text) {
                    print("Wrote to \(Utils.directory!.path) success!")
                    success()
                } else {
                    NotificationCenter.default.post(name: Notification.Name("alert"), object: "wrote to \(Utils.directory!.path) failed")
                }
            }
        }
    }
}
