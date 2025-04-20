//
//  Item.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import Foundation
import SwiftData



@Model
final class Item {
    var id: UUID
    var title: String
    var content: String
    var timestamp: Date
    var category: PostCategory
    
    init(title: String, content: String, category: PostCategory = .app, timestamp: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.category = category
        self.timestamp = timestamp
    }
}
