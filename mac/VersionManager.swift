//
//  VersionManager.swift
//  node-box
//
//  Created by Learning on 2018/8/24.
//  Copyright © 2018 Learning. All rights reserved.
//

import Foundation
import Alamofire

let VERSION_URL = "https://raw.githubusercontent.com/learning/node-box/master/versions.json"

class VersionManager {
    static private var directory: URL? = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent(Bundle.main.bundleIdentifier!, isDirectory: true)

    /**
     * Get a local file from file system
     *
     * - parameters:
     *   - name: The file's name
     */
    static private func getFile(name: String) -> URL? {
        if let pathComponent = directory?.appendingPathComponent(name) {
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
        if !FileManager.default.fileExists(atPath: (directory?.path)!) {
            do {
                try FileManager.default.createDirectory(at: directory!, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("Create directory \(directory!.path) failed")
                return false
            }
        }
        let file: URL? = directory?.appendingPathComponent(name)
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
    static func getData () -> Dictionary<String, Array<Dictionary<String, Any>>>? {
        let file: URL? = getFile(name: "versions.json")
        if file != nil {
            do {
                let data: Dictionary<String, Array<Dictionary<String, Any>>> =
                    try JSONSerialization.jsonObject(with: Data(contentsOf: file!), options: []) as! Dictionary<String, Array<Dictionary<String, Any>>>
                return data
            } catch {
                return nil
            }

        } else {
            return nil
        }
    }
    
    static func updateDownloadList (onSuccess success: @escaping () -> Void) {
        Alamofire.request(VERSION_URL).responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // Write json to file
                if writeFile(name: "versions.json", content: utf8Text) {
                    print("Wrote to \(directory!.path) success!")
                    success()
                } else {
                    NotificationCenter.default.post(name: Notification.Name("alert"), object: "wrote to \(directory!.path) failed")
                }
            }
        }
    }
}
