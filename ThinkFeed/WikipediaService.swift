//
//  WikipediaService.swift
//  ThinkFeed
//

import Foundation

struct WikipediaSummary: Codable {
    let title: String
    let extract: String
    let contentUrls: ContentUrls?

    enum CodingKeys: String, CodingKey {
        case title, extract
        case contentUrls = "content_urls"
    }

    struct ContentUrls: Codable {
        let desktop: DesktopUrl?
        struct DesktopUrl: Codable {
            let page: String?
        }
    }
}

actor WikipediaService {
    static let shared = WikipediaService()

    private var cache: [String: WikipediaSummary] = [:]

    /// Extracts the page title from a Wikipedia URL.
    static func pageTitle(from urlString: String) -> String? {
        guard let url = URL(string: urlString.trimmingCharacters(in: .whitespacesAndNewlines)),
              let host = url.host,
              host.contains("wikipedia.org"),
              url.pathComponents.count >= 3,
              url.pathComponents[1] == "wiki" else {
            return nil
        }
        return url.pathComponents[2...].joined(separator: "/")
    }

    func fetchSummary(for wikiURL: String) async throws -> WikipediaSummary {
        guard let title = Self.pageTitle(from: wikiURL) else {
            throw URLError(.badURL)
        }

        if let cached = cache[title] {
            return cached
        }

        let apiURL = URL(string: "https://en.wikipedia.org/api/rest_v1/page/summary/\(title)")!
        var request = URLRequest(url: apiURL)
        request.setValue("ThinkFeed/1.0 (educational app)", forHTTPHeaderField: "Api-User-Agent")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let summary = try JSONDecoder().decode(WikipediaSummary.self, from: data)
        cache[title] = summary
        return summary
    }
}
