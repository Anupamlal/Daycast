//
//  GeocodingRepository.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

protocol GeocodingRepository: Sendable {
    func searchDestinations(query: String) async throws -> [Destination]
}

struct OpenMeteoGeocodingRepository: GeocodingRepository {
    private let service: GeocodingServicing

    init(service: GeocodingServicing = OpenMeteoGeocodingService()) {
        self.service = service
    }

    func searchDestinations(query: String) async throws -> [Destination] {
        try await service.searchDestinations(query: query)
    }
}
