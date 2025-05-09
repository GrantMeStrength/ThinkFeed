//
//  ThinkFeedApp.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import SwiftUI
import SwiftData

@main
struct ThinkFeedApp: App {
    init() {
        

    }
    
    var body: some Scene {
        WindowGroup {
            FeedView()
        }
        .modelContainer(for: Item.self, isUndoEnabled: true)
    }
}
