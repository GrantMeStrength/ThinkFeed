//
//  SettingsView.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedCategories") private var selectedCategoriesData: Data = try! JSONEncoder().encode(Set(PostCategory.allCases))
    @AppStorage("showLikedOnly") private var showLikedOnly = false
    @AppStorage("enableWikipedia") private var enableWikipedia = true
    @AppStorage("appearanceMode") private var appearanceMode: Int = 0
    @Environment(\.dismiss) private var dismiss
    
    private var selectedCategories: Binding<Set<PostCategory>> {
        Binding(
            get: {
                (try? JSONDecoder().decode(Set<PostCategory>.self, from: selectedCategoriesData)) ?? Set(PostCategory.allCases)
            },
            set: { newValue in
                if let encoded = try? JSONEncoder().encode(newValue) {
                    selectedCategoriesData = encoded
                }
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Feed Categories")) {
                    ForEach(PostCategory.allCases, id: \.self) { category in
                        Toggle(isOn: Binding(
                            get: { selectedCategories.wrappedValue.contains(category) },
                            set: { isSelected in
                                if isSelected {
                                    selectedCategories.wrappedValue.insert(category)
                                } else {
                                    selectedCategories.wrappedValue.remove(category)
                                }
                            }
                        )) {
                            HStack {
                                Text(category.icon)
                                Text(category.rawValue)
                            }
                        }
                    }
                    
                    Button("Select All") {
                        selectedCategories.wrappedValue = Set(PostCategory.allCases)
                    }
                    
                    Button("Clear All") {
                        selectedCategories.wrappedValue = []
                    }
                }
                
                Section {
                    Toggle("❤️ Show only liked posts", isOn: $showLikedOnly)
                }
                
                Section(header: Text("Content")) {
                    Toggle("📖 Wikipedia content", isOn: $enableWikipedia)
                }
                
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $appearanceMode) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
} 
