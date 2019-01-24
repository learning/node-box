//
//  Branch.swift
//  node-box
//
//  Created by Learning on 2019/1/24.
//  Copyright © 2019 Learning. All rights reserved.
//

import Foundation

/**
 * A Node.js version branch
 */
class Branch {
    var name:String
    var pattern:String
    
    init(data: Dictionary<String, String>) {
        self.name = data["name"] ?? ""
        self.pattern = data["pattern"] ?? ""
    }
}
