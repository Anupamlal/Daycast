//
//  URLSessionHTTPClient.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

protocol HTTPClient: Sendable {
    func data(from url: URL) async throws -> Data
}

struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func data(from url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenMeteoServiceError.invalidResponse
        }
        guard (200 ... 299).contains(httpResponse.statusCode) else {
            throw OpenMeteoServiceError.httpStatus(httpResponse.statusCode)
        }
        return data
    }
}

enum OpenMeteoServiceError: Error, Equatable {
    case invalidResponse
    case httpStatus(Int)
    case decodingFailed
}
