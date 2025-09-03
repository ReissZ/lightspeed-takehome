//
//  APIServiceTests.swift
//  LightspeedTakeHomeTests
//
//  Created by Reiss Zurbyk on 2025-09-02.
//

import XCTest
@testable import LightspeedTakeHome

final class APIServiceTests: XCTestCase {

    func test_fetchPhotos_decodesOneItem() async throws {
        let json = """
        [
          {
            "id": "10",
            "author": "Test Author",
            "width": 5000,
            "height": 3333,
            "url": "https://unsplash.com/photos/abc",
            "download_url": "https://picsum.photos/id/10/5000/3333"
          }
        ]
        """.data(using: .utf8)!

        let response = HTTPURLResponse(url: URL(string: "https://picsum.photos/v2/list")!,
                                       statusCode: 200, httpVersion: nil, headerFields: nil)!
        URLProtocolStub.stubbedResponse = (json, response)

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)

        let api = APIService(session: session)

        let result = try await api.fetchPhotos(page: nil, limit: nil)

        // Checks
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "10")
        XCTAssertEqual(result.first?.author, "Test Author")
        XCTAssertEqual(result.first?.download_url, "https://picsum.photos/id/10/5000/3333")
    }
}
