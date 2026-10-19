//
//  GeocodingServicing.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

protocol GeocodingServicing: Sendable {
    func searchDestinations(query: String) async throws -> [Destination]
}

struct OpenMeteoGeocodingService: GeocodingServicing {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.httpClient = httpClient
    }

    func searchDestinations(query: String) async throws -> [Destination] {
        let endpoint = OpenMeteoEndpoint.geocodingSearch(
            query: query,
            resultCount: OpenMeteoRequestParameter.geocodingResultCount.intValue
        )
        let data = try await httpClient.data(from: endpoint.url)
        do {
            let response = try JSONDecoder().decode(OpenMeteoGeocodingResponse.self, from: data)
            return OpenMeteoGeocodingMapper.map(response: response)
        } catch {
            throw OpenMeteoServiceError.decodingFailed
        }
    }
}
