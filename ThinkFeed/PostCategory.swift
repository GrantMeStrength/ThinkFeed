//
//  PostCategory.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import Foundation
enum PostCategory: String, Codable, CaseIterable {
    case app = "ThinkFeed"
    case anatomy = "Anatomy"
    case arts = "Arts"
    case biology = "Biology"
    case business = "Business"
    case chemistry = "Chemistry"
    case computerScience = "Computer Science"
    case economics = "Economics"
    case health = "Health"
    case history = "History"
    case languages = "Languages"
    case math = "Math"
    case physics = "Physics"
    case science = "Science"
    case technology = "Technology"
    

    var icon: String {
        switch self {
        case .app: return "👩‍💻"
        case .anatomy: return "🫀"
        case .arts: return "🎨"
        case .biology: return "🧬"
        case .business: return "💼"
        case .chemistry: return "🧪"
        case .computerScience: return "💻"
        case .economics: return "💸"
        case .health: return "🏥"
        case .history: return "📜"
        case .languages: return "🌍"
        case .math: return "𝛑"
        case .physics: return "🔭"
        case .science: return "🔬"
        case .technology: return "💻"
        }
    }
}
