//
//  Item.swift
//  PerfectCircle
//
//  Created by Lynn McMorrow on 6/22/26.
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
