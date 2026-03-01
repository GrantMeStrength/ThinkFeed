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

    var wikiSearchTerms: [String] {
        switch self {
        case .app: return []
        case .anatomy: return ["human anatomy", "organ system", "skeletal muscle", "nervous system"]
        case .arts: return ["art history", "famous paintings", "sculpture art", "modern art movement"]
        case .biology: return ["cell biology", "genetics", "ecology", "evolution biology"]
        case .business: return ["business strategy", "entrepreneurship", "management theory", "marketing"]
        case .chemistry: return ["chemical element", "organic chemistry", "chemical reaction", "periodic table"]
        case .computerScience: return ["algorithm", "programming language", "data structure", "computer architecture"]
        case .economics: return ["microeconomics", "macroeconomics", "economic theory", "fiscal policy"]
        case .health: return ["nutrition", "exercise physiology", "mental health", "public health"]
        case .history: return ["world history", "ancient civilization", "industrial revolution", "modern history"]
        case .languages: return ["linguistics", "language family", "phonology", "syntax linguistics"]
        case .math: return ["number theory", "geometry", "algebra", "mathematical proof"]
        case .physics: return ["quantum mechanics", "classical mechanics", "thermodynamics", "astrophysics"]
        case .science: return ["scientific method", "natural science", "earth science", "space exploration"]
        case .technology: return ["artificial intelligence", "internet technology", "robotics", "semiconductor"]
        }
    }
}
