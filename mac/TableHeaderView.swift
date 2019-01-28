//
//  TableHeaderView.swift
//  node-box
//
//  Created by Learning on 2019/1/24.
//  Copyright © 2019 Learning. All rights reserved.
//

import Cocoa

class TableHeaderView: NSTableHeaderView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Remove 1px border on the top
        let topBorderBox = NSRect(x: 0, y: 0, width: bounds.size.width, height: 1)
        if dirtyRect.intersects(topBorderBox) {
            NSColor.controlBackgroundColor.setFill()
            topBorderBox.fill()
        }
    }
    
}
