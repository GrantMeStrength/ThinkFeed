//
//  Item.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import Foundation
import SwiftData

enum PostCategory: String, Codable, CaseIterable {
    case technology = "Technology"
    case science = "Science"
    case health = "Health"
    case business = "Business"
    case arts = "Arts"
    case lifestyle = "Lifestyle"
    case education = "Education"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .technology: return "💻"
        case .science: return "🔬"
        case .health: return "🏥"
        case .business: return "💼"
        case .arts: return "🎨"
        case .lifestyle: return "🌟"
        case .education: return "📚"
        case .other: return "📌"
        }
    }
}

@Model
final class Item {
    var id: UUID
    var title: String
    var content: String
    var timestamp: Date
    var category: PostCategory
    
    init(title: String, content: String, category: PostCategory = .other, timestamp: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.category = category
        self.timestamp = timestamp
    }
}
