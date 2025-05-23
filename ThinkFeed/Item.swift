//
//  Item.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import Foundation
import SwiftData
import SwiftUI


@Model
class Item {
    var title: String
    var content: String
    var category: PostCategory
    var timestamp: Date
    var imageFileName: String?
    var url: String? = nil
    var image: Image? {
        guard let name = imageFileName, !name.isEmpty else { return nil }
        return Image(name)
    }
    var isLiked: Bool = false
    var correctAnswerCount: Int = 0

    init(title: String, content: String, category: PostCategory, imageFileName: String? = nil, timestamp: Date = .now, url: String? = nil) {
        self.title = title
        self.content = content
        self.category = category
        self.timestamp = timestamp
        self.imageFileName = imageFileName
        self.url = url
        self.isLiked = isLiked
        self.correctAnswerCount = correctAnswerCount
    }
}
