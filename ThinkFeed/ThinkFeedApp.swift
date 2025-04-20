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
        print("Application starting...")

       // UserDefaults.standard.set(true, forKey: "_SwiftData_Debug_Enabled")
    }
    
    var body: some Scene {
        WindowGroup {
            FeedView()
        }
        .modelContainer(for: Item.self, isUndoEnabled: true)
    }
}
