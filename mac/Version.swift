//
//  Version.swift
//  node-box
//
//  Created by Learning on 2019/1/24.
//  Copyright © 2019 Learning. All rights reserved.
//

import Foundation

class Version {
    var version:String;
    var npmVersion:String;
    var v8Version:String;
    var nodeModuleVersion:String;
    var url:String
    var date:String;

    init(data: Dictionary<String, Any>) {
        self.version = data["version"] as? String ?? ""
        self.npmVersion = data["npm"] as? String ?? ""
        self.v8Version = data["v8"] as? String ?? ""
        self.nodeModuleVersion = data["node-module-version"] as? String ?? ""
        self.url = (data["url"] as! Dictionary<String, String>)["darwin"] ?? ""
        self.date = data["date"] as? String ?? ""
    }
}
