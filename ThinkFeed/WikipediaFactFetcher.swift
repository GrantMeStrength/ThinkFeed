//
//  WikipediaFactFetcher.swift
//  ThinkFeed
//

import Foundation

struct WikipediaSearchResult: Codable {
    let query: SearchQuery?

    struct SearchQuery: Codable {
        let search: [SearchItem]
    }

    struct SearchItem: Codable {
        let title: String
        let pageid: Int
    }
}

struct FetchedFact {
    let title: String
    let content: String
    let category: PostCategory
    let url: String
}

actor WikipediaFactFetcher {
    static let shared = WikipediaFactFetcher()

    /// Fetches new facts for a category by searching Wikipedia and extracting summaries.
    func fetchFacts(for category: PostCategory, count: Int, existingTitles: Set<String>) async -> [FetchedFact] {
        let terms = category.wikiSearchTerms
        guard !terms.isEmpty else { return [] }

        let term = terms.randomElement()!
        let offset = Int.random(in: 0..<20)

        guard let searchURL = URL(string:
            "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=\(term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? term)&srnamespace=0&srlimit=10&sroffset=\(offset)&format=json"
        ) else { return [] }

        var request = URLRequest(url: searchURL)
        request.setValue("ThinkFeed/1.0 (educational app)", forHTTPHeaderField: "Api-User-Agent")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let searchResult = try JSONDecoder().decode(WikipediaSearchResult.self, from: data)

            guard let items = searchResult.query?.search else { return [] }

            // Filter out titles we already have, then shuffle for variety
            let candidates = items.filter { !existingTitles.contains($0.title) }.shuffled()

            var facts: [FetchedFact] = []
            for candidate in candidates where facts.count < count {
                if let fact = await fetchFact(titled: candidate.title, category: category) {
                    facts.append(fact)
                }
            }
            return facts
        } catch {
            return []
        }
    }

    private func fetchFact(titled title: String, category: PostCategory) async -> FetchedFact? {
        let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? title
        guard let url = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(encodedTitle)") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.setValue("ThinkFeed/1.0 (educational app)", forHTTPHeaderField: "Api-User-Agent")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else { return nil }

            let summary = try JSONDecoder().decode(WikipediaSummary.self, from: data)

            let content = extractFirstSentences(from: summary.extract, count: 2)
            guard !content.isEmpty, content.count > 20 else { return nil }

            let pageURL = summary.contentUrls?.desktop?.page ?? "https://en.wikipedia.org/wiki/\(encodedTitle)"

            return FetchedFact(
                title: summary.title,
                content: content,
                category: category,
                url: pageURL
            )
        } catch {
            return nil
        }
    }

    private func extractFirstSentences(from text: String, count: Int) -> String {
        var sentences: [String] = []
        var remaining = text[text.startIndex...]

        for _ in 0..<count {
            guard let range = remaining.range(of: ". ", options: .literal) ?? remaining.range(of: ".\n", options: .literal) else {
                // Last sentence without trailing period+space
                if !remaining.isEmpty && remaining.hasSuffix(".") {
                    sentences.append(String(remaining))
                }
                break
            }
            sentences.append(String(remaining[remaining.startIndex...range.lowerBound]))
            remaining = remaining[range.upperBound...]
        }

        return sentences.joined(separator: " ")
    }
}
