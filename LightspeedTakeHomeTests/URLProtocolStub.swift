//
//  URLProtocolStub.swift
//  LightspeedTakeHomeTests
//
//  Created by Reiss Zurbyk on 2025-09-03.
//

import Foundation

final class URLProtocolStub: URLProtocol {
    static var stubbedResponse: (Data, HTTPURLResponse)?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let (data, response) = URLProtocolStub.stubbedResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
        }
    }

    override func stopLoading() {}
}
