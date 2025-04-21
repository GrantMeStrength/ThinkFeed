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
    var url: String? // Added this line
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
        
        let uniquePosts = sampleData.posts.uniqued { $0.title + "::" + $0.content }

        return try uniquePosts.map { post in
            guard let category = PostCategory.allCases.first(where: { $0.rawValue.lowercased() == post.category.lowercased() }) else {
                print("Error with category: \(post.category)")
                throw DataError.invalidCategory
            }
            
            //print("Loading post: \(post.title), url: \(post.url ?? "nil")")

            return Item(
                title: post.title,
                content: post.content,
                category: category,
                imageFileName: post.imageFileName,
                timestamp: Date().addingTimeInterval(post.timestampOffset),
                url: post.url ?? (post.title.lowercased().contains("welcome") ? "https://en.wikipedia.org/wiki/ThinkFeed" : nil)
            )
        }
    }
}

extension Array {
    func uniqued<T: Hashable>(by key: (Element) -> T) -> [Element] {
        var seen = Set<T>()
        return self.filter { seen.insert(key($0)).inserted }
    }
}
