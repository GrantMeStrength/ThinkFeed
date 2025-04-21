//
//  PostCategory.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import Foundation

enum PostCategory: String, Codable, CaseIterable {
    case app = "ThinkFeed"
    case technology = "Technology"
    case science = "Science"
    case health = "Health"
    case business = "Business"
    case arts = "Arts"
    case math = "Math"
    case education = "Education"
    case history = "History"
    case computerScience = "Computer Science"
    case languages = "Languages"
    case economics = "Economics"
    case quiz = "Quiz"
    
    var icon: String {
        switch self {
        case .app: return "👩‍💻"
        case .technology: return "💻"
        case .science: return "🔬"
        case .health: return "🏥"
        case .business: return "💼"
        case .arts: return "🎨"
        case .math: return "𝛑"
        case .education: return "📚"
        case .history: return "📜"
        case .computerScience: return "💻"
        case .languages: return "🌍"
        case .economics: return "💸"
        case .quiz: return "🤔"
        }
    }
} 
