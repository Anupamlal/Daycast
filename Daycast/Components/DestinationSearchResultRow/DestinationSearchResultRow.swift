//
//  DestinationSearchResultRow.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DestinationSearchResultRow: View {
    let destination: Destination
    let onSelect: () -> Void

    var body: some View {
        DestinationLocationRow(
            title: destination.name,
            subtitle: destination.subtitle,
            action: onSelect
        )
    }
}
