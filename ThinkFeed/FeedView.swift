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
    @State private var selectedAnswer: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.category.icon)
                Text(item.category.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }

            Text(item.title)
                .font(.headline)

            if item.category == .quiz {
                let answers = item.content.components(separatedBy: "|") // "Q?|A|B|C|Correct"
                if answers.count >= 5 {
                    Text(answers[0]) // the question
                        .font(.body)
                        .foregroundColor(.primary)

                    ForEach(1..<4, id: \.self) { index in
                        Button(action: {
                            selectedAnswer = answers[index]
                        }) {
                            Text(answers[index])
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }

                    if let selected = selectedAnswer {
                        if selected == answers[4] {
                            Text("✅ Correct!")
                                .foregroundColor(.green)
                                .font(.footnote)
                        } else {
                            Text("❌ Incorrect. Correct answer: \(answers[4])")
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                    }
                } else {
                    Text("⚠️ Invalid quiz format.")
                        .foregroundColor(.orange)
                        .font(.footnote)
                }
            } else {
                Text(item.content)
                    .font(.body)
                    .foregroundColor(.secondary)

                if let urlString = item.url?.trimmingCharacters(in: .whitespacesAndNewlines),
                   let url = URL(string: urlString) {
                    Link("Learn More", destination: url)
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.top, 4)
                } 
            }
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
    @AppStorage("hasLoadedInitialData") private var hasLoadedInitialData = false
    @AppStorage("selectedCategories") private var selectedCategoriesData: Data = try! JSONEncoder().encode(Set(PostCategory.allCases))
    @State private var showingSettings = false
    @State private var showError = false
    @State private var errorMessage = ""
    
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
                if !hasLoadedInitialData && allItems.isEmpty {
                    loadSampleData()
                    hasLoadedInitialData = true
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func loadSampleData() {
        do {
            let items = try DataManager.shared.loadSampleData()
            for item in items {
                modelContext.insert(item)
            }
            try modelContext.save()
        } catch {
            errorMessage = "Failed to load sample data: \(error.localizedDescription)"
            showError = true
            print("Error loading sample data: \(error)")
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Item.self, configurations: config)

        let sampleItems = [
            Item(title: "🎉 Preview Post 1",
                 content: "This is how your posts will look in the feed. Notice the clean layout and typography.",
                 category: .technology,
                 timestamp: Date().addingTimeInterval(-7200)),
            Item(title: "🌈 Art Exhibition",
                 content: "Virtual art gallery opening this weekend!",
                 category: .arts,
                 timestamp: Date(), url: "https://example.com/exhibition")
        ]

        for item in sampleItems {
            container.mainContext.insert(item)
        }

        return FeedView()
            .modelContainer(container)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(item: Item(
            title: "Preview Post",
            content: "This is a preview of an individual post card. It shows how a single post looks in isolation.",
            category: .technology,
            url: "https://example.com"
        ))
        .padding()
    }
}
