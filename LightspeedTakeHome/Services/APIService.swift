//
//  APIService.swift
//  LightspeedTakeHome
//
//  Created by Reiss Zurbyk on 2025-09-02.
//

import Foundation

// MARK: - Picsum API Service

protocol APIServiceProtocol {
    func fetchPhotos(page: Int?, limit: Int?) async throws -> [PhotoDTO]
}

final class APIService: APIServiceProtocol {
    private let session: URLSession
    private let baseURL = URL(string: "https://picsum.photos/v2/list")!

    init(session: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.requestCachePolicy = .returnCacheDataElseLoad
        cfg.timeoutIntervalForRequest = 15
        cfg.timeoutIntervalForResource = 30
        return URLSession(configuration: cfg)
    }()) {
        self.session = session
    }

    func fetchPhotos(page: Int? = nil, limit: Int? = nil) async throws -> [PhotoDTO] {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        var items: [URLQueryItem] = []
        if let page { items.append(.init(name: "page", value: String(page))) }
        if let limit { items.append(.init(name: "limit", value: String(limit))) }
        if !items.isEmpty { components.queryItems = items }

        return try await retry(times: 2) {
            let (data, response) = try await self.session.data(from: components.url!)
            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                throw URLError(.badServerResponse)
            }
            return try JSONDecoder().decode([PhotoDTO].self, from: data)
        }
    }

    private func retry<T>(times: Int, _ op: @escaping () async throws -> T) async throws -> T {
        var attempt = 0
        while true {
            do { return try await op() }
            catch {
                guard attempt < times else { throw error }
                attempt += 1
                let backoff = UInt64(Double(300_000_000) * pow(1.6, Double(attempt))) // 0.3s, 0.48s...
                try await Task.sleep(nanoseconds: backoff)
            }
        }
    }
}
