//
//  OpenMeteoGeocodingResponse.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct OpenMeteoGeocodingResponse: Decodable {
    let results: [OpenMeteoGeocodingResult]?
}

struct OpenMeteoGeocodingResult: Decodable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let admin1: String?
    let country: String?

    func asDestination() -> Destination {
        Destination(
            id: id,
            name: name,
            region: admin1,
            country: country,
            latitude: latitude,
            longitude: longitude
        )
    }
}
