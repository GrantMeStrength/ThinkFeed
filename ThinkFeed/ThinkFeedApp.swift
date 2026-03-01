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
    @AppStorage("appearanceMode") private var appearanceMode: Int = 0

    var body: some Scene {
        WindowGroup {
            FeedView()
                .preferredColorScheme(colorScheme)
                .tint(.indigo)
        }
        .modelContainer(for: Item.self, isUndoEnabled: true)
    }

    private var colorScheme: ColorScheme? {
        switch appearanceMode {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }
}
