//
//  Utils.swift
//  node-box
//
//  Created by Learning on 2019/1/25.
//  Copyright © 2019 Learning. All rights reserved.
//

import Foundation

class Utils {
    static var directory: URL? = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent(Bundle.main.bundleIdentifier!, isDirectory: true)

    static public func run(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.currentDirectoryPath = directory!.path
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    static public func runAndGetOutput(_ args: String...) -> String?
    {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.currentDirectoryPath = directory!.path
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        
        return output
    }
}
