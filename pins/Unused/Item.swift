//
//  Item.swift
//  pins
//
//  Created by yuncoffee on 12/13/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
