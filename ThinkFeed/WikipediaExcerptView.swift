//
//  WikipediaExcerptView.swift
//  ThinkFeed
//

import SwiftUI

struct WikipediaExcerptView: View {
    let wikiURL: String

    @State private var summary: WikipediaSummary?
    @State private var isLoading = false
    @State private var isExpanded = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if isExpanded {
                if isLoading {
                    HStack {
                        ProgressView()
                        Text("Loading from Wikipedia…")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else if let summary {
                    Text(summary.extract)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(6)

                    if let pageURL = summary.contentUrls?.desktop?.page,
                       let url = URL(string: pageURL) {
                        Link("Read more on Wikipedia →", destination: url)
                            .font(.caption2)
                    }
                } else if let errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
                if isExpanded && summary == nil && !isLoading {
                    fetchSummary()
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: isExpanded ? "chevron.up" : "book")
                    Text(isExpanded ? "Hide" : "Learn More")
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
        }
    }

    private func fetchSummary() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let result = try await WikipediaService.shared.fetchSummary(for: wikiURL)
                summary = result
            } catch {
                errorMessage = "Could not load summary."
            }
            isLoading = false
        }
    }
}
