//
//  SettingsView.swift
//  ThinkFeed
//
//  Created by John Kennedy on 4/20/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedCategories") private var selectedCategoriesData: Data = try! JSONEncoder().encode(Set(PostCategory.allCases))
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
        NavigationView {
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
                   
                    
                }
                
                Section {
                    Toggle("Show only liked posts", isOn: Binding(
                        get: { UserDefaults.standard.bool(forKey: "showLikedOnly") },
                        set: { UserDefaults.standard.set($0, forKey: "showLikedOnly") }
                    ))
                }
                
                Section {
                    Button("Select All") {
                        selectedCategories.wrappedValue = Set(PostCategory.allCases)
                    }
                    
                    Button("Clear All") {
                        selectedCategories.wrappedValue = []
                    }
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
