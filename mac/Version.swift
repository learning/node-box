//
//  Version.swift
//  node-box
//
//  Created by Learning on 2019/1/24.
//  Copyright © 2019 Learning. All rights reserved.
//

import Foundation
import Alamofire

class Version {
    var version:String
    var npmVersion:String
    var v8Version:String
    var nodeModuleVersion:String
    var url:String
    var filename:String
    var date:String
    var isDownloaded:Bool
    var isDownloading:Bool
    var isError:Bool
    var percentage:Double
    var isActive:Bool

    init(data: Dictionary<String, Any>) {
        self.version = data["version"] as? String ?? ""
        self.npmVersion = data["npm"] as? String ?? ""
        self.v8Version = data["v8"] as? String ?? ""
        self.nodeModuleVersion = data["node-module-version"] as? String ?? ""
        self.url = (data["url"] as! Dictionary<String, String>)["darwin"] ?? ""
        self.filename = String((self.url.split(separator: "/").last?.dropLast(7))!)
        self.date = data["date"] as? String ?? ""
        self.isDownloaded = false
        self.isDownloading = false
        self.isError = false
        self.percentage = 0
        self.isActive = false
    }
    
    func download (onProgress progress: @escaping () -> Void) {
        self.isDownloading = true
        self.percentage = 0
        progress()
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = Utils.directory!
            let fileURL = documentsURL.appendingPathComponent(self.filename + ".tar.xz")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(self.url, to: destination)
            .downloadProgress { p in
                self.percentage = p.fractionCompleted * 100
                progress()
            }
            .responseData { r in
                self.isDownloading = false
                if self.untar() == 0 {
                    self.percentage = 100
                    self.isDownloaded = true
                    progress()
                    NotificationCenter.default.post(name: Notification.Name("reload-list"), object: nil)
                } else {
                    self.isError = true
                    self.percentage = 0
                    self.isDownloaded = false
                    progress()
                }

            }
    }
    
    func untar() -> Int32 {
        let res = Utils.run("tar", "xf", self.filename + ".tar.xz")
        if res == 0 {
            return Utils.run("rm", self.filename + ".tar.xz")
        }
        return res
    }
}
