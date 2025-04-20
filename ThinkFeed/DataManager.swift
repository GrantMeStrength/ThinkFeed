//
//  DataManager.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import Foundation
import SwiftUI

struct SamplePost: Codable {
    let title: String
    let content: String
    let category: String
    let imageFileName: String?
    let timestampOffset: TimeInterval
}

struct SampleData: Codable {
    let posts: [SamplePost]
}

enum DataError: Error {
    case fileNotFound
    case decodingError
    case invalidCategory
}

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    func loadSampleData() throws -> [Item] {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            throw DataError.fileNotFound
        }
        
        let data = try Data(contentsOf: url)
        let sampleData = try JSONDecoder().decode(SampleData.self, from: data)
        
        return try sampleData.posts.map { post in
            guard let category = PostCategory.allCases.first(where: { $0.rawValue.lowercased() == post.category.lowercased() }) else {
                print("Error with category: \(post.category)")
                throw DataError.invalidCategory
            }
           
            return Item(
                title: post.title,
                content: post.content,
                category: category,
                timestamp: Date().addingTimeInterval(post.timestampOffset),
            )
        }
    }
} 
