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
    
    static private func writeFile(name: String, content: String) -> Bool {
        print("directory    \(directory)")
        // TODO: Is directory exists?
        let file: URL? = directory?.appendingPathComponent(name)
        print("URL         \(file)")
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

    static func getDownloadList () -> Array<Dictionary<String, Any>>? {
        let file: URL? = getFile(name: "versions.json")
        if file != nil {
            do {
                let downloads: Array<Dictionary<String, Any>> =
                    try JSONSerialization.jsonObject(with: Data(contentsOf: file!), options: []) as! Array<Dictionary<String, Any>>
                return downloads
            } catch {
                return nil
            }

        } else {
            return nil
        }
    }
    
    static func updateDownloadList () {
        Alamofire.request(VERSION_URL).responseJSON { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
                if writeFile(name: "versions.json", content: utf8Text) {
                    print("wrote to \(directory) successed")
                } else {
                    print("wrote to \(directory) failed")
                }
            }
        }
    }
}
