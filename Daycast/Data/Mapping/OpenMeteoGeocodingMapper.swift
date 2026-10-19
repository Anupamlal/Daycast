//
//  OpenMeteoGeocodingMapper.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum OpenMeteoGeocodingMapper {
    static func map(response: OpenMeteoGeocodingResponse) -> [Destination] {
        response.results?.map { $0.asDestination() } ?? []
    }
}
