//
//  FeedView.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import SwiftUI
import SwiftData
import Foundation

struct PostView: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.category.icon)
                Text(item.category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(item.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(item.title)
                .font(.headline)
            Text(item.content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct FeedView: View {
    @Query(sort: \Item.timestamp, order: .reverse) private var allItems: [Item]
    @Environment(\.modelContext) private var modelContext
    @AppStorage("selectedCategories") private var selectedCategoriesData: Data = try! JSONEncoder().encode(Set(PostCategory.allCases))
    @State private var showingSettings = false
    
    private var selectedCategories: Set<PostCategory> {
        (try? JSONDecoder().decode(Set<PostCategory>.self, from: selectedCategoriesData)) ?? Set(PostCategory.allCases)
    }
    
    private var filteredItems: [Item] {
        allItems.filter { selectedCategories.contains($0.category) }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if filteredItems.isEmpty {
                    ContentUnavailableView(
                        "No Posts",
                        systemImage: "text.bubble",
                        description: Text("No posts available for selected categories")
                    )
                    .padding(.top, 40)
                } else {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(filteredItems) { item in
                            PostView(item: item)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("ThinkFeed")
            .toolbar {
                Button(action: { showingSettings = true }) {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .task {
                if allItems.isEmpty {
                    addSampleData()
                }
            }
        }
    }
    
    private func addSampleData() {
        let samplePosts = [
            Item(title: "Welcome to ThinkFeed!", 
                 content: "This is your first post on ThinkFeed. Start exploring the social experience.",
                 category: .technology,
                 timestamp: Date().addingTimeInterval(-3600 * 2)),
            
            Item(title: "The Future of AI", 
                 content: "Exploring the latest developments in artificial intelligence and machine learning.",
                 category: .science,
                 timestamp: Date().addingTimeInterval(-3600)),
            
            Item(title: "Healthy Living Tips", 
                 content: "Simple ways to maintain a healthy lifestyle in our busy modern world.",
                 category: .health,
                 timestamp: Date().addingTimeInterval(-1800)),
            
            Item(title: "Creative Writing Workshop", 
                 content: "Join us for an online workshop on creative writing techniques.",
                 category: .education,
                 timestamp: Date()),
            
            Item(title: "Modern Art Trends", 
                 content: "Exploring the latest trends in contemporary art.",
                 category: .arts,
                 timestamp: Date().addingTimeInterval(-300)),
            
            Item(title: "Business Strategy", 
                 content: "Essential business strategies for the modern entrepreneur.",
                 category: .business,
                 timestamp: Date().addingTimeInterval(-7200))
        ]
        
        for post in samplePosts {
            modelContext.insert(post)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Item.self, configurations: config)
    
    // Add sample items with different categories and timestamps
    let sampleItems = [
        Item(title: "🎉 Preview Post 1", 
             content: "This is how your posts will look in the feed. Notice the clean layout and typography.",
             category: .technology,
             timestamp: Date().addingTimeInterval(-7200)),
        
        Item(title: "📱 Latest Tech Trends", 
             content: "SwiftUI makes it easy to create beautiful, responsive interfaces.",
             category: .technology,
             timestamp: Date().addingTimeInterval(-3600)),
        
        Item(title: "💡 Science Discovery", 
             content: "Breaking news in quantum computing research.",
             category: .science,
             timestamp: Date().addingTimeInterval(-1800)),
        
        Item(title: "🌈 Art Exhibition", 
             content: "Virtual art gallery opening this weekend!",
             category: .arts,
             timestamp: Date())
    ]
    
    for item in sampleItems {
        container.mainContext.insert(item)
    }
    
    return FeedView()
        .modelContainer(container)
}

#Preview("Post Card") {
    PostView(item: Item(
        title: "Preview Post",
        content: "This is a preview of an individual post card. It shows how a single post looks in isolation.",
        category: .technology
    ))
    .padding()
}
