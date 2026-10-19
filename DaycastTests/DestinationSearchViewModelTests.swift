//
//  DestinationSearchViewModelTests.swift
//  DaycastTests
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import XCTest
@testable import Daycast

@MainActor
final class DestinationSearchViewModelTests: XCTestCase {
    func testStaleSearchResponseIgnored() async {
        let repository = DelayedGeocodingRepository(delay: .milliseconds(200), results: [
            Destination(id: 1, name: "Old", region: nil, country: "X", latitude: 0, longitude: 0),
        ])
        let viewModel = DestinationSearchViewModel(geocodingRepository: repository)

        viewModel.query = "Lon"
        viewModel.queryDidChange()
        try? await Task.sleep(for: .milliseconds(50))
        viewModel.query = "London"
        viewModel.queryDidChange()
        try? await Task.sleep(for: .milliseconds(700))

        XCTAssertEqual(viewModel.searchResults.first?.name, "London")
    }

    func testShortQueryReturnsToRecentsMode() {
        let viewModel = DestinationSearchViewModel(geocodingRepository: StubGeocodingRepository(results: []))
        viewModel.query = "a"
        viewModel.queryDidChange()
        XCTAssertEqual(viewModel.listMode, .recentDestinations)
        XCTAssertEqual(viewModel.searchStatus, .idle)
    }
}

private struct StubGeocodingRepository: GeocodingRepository {
    let results: [Destination]

    func searchDestinations(query: String) async throws -> [Destination] {
        results
    }
}

private struct DelayedGeocodingRepository: GeocodingRepository {
    let delay: Duration
    let results: [Destination]
    private var lastQuery: String = ""

    func searchDestinations(query: String) async throws -> [Destination] {
        lastQuery = query
        try await Task.sleep(for: delay)
        return [
            Destination(
                id: 1,
                name: query,
                region: nil,
                country: "X",
                latitude: 0,
                longitude: 0
            ),
        ]
    }
}
