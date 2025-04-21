//
//  PostCategory.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import Foundation

enum PostCategory: String, Codable, CaseIterable {
    case technology = "Technology"
    case science = "Science"
    case health = "Health"
    case business = "Business"
    case arts = "Arts"
    case math = "Math"
    case education = "Education"
    case history = "History"
    case app = "ThinkFeed"
    case computerScience = "Computer Science"
    case languages = "Languages"
    case economics = "Economics"
    case quiz = "Quiz"
    
    var icon: String {
        switch self {
        case .technology: return "💻"
        case .science: return "🔬"
        case .health: return "🏥"
        case .business: return "💼"
        case .arts: return "🎨"
        case .math: return "🌟"
        case .education: return "📚"
        case .history: return "📜"
        case .app: return "👩‍💻"
        case .computerScience: return "💻"
        case .languages: return "🌍"
        case .economics: return "💸"
        case .quiz: return "🧠"
        }
    }
} 
