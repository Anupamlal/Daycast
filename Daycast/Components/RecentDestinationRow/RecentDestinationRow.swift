//
//  RecentDestinationRow.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct RecentDestinationRow: View {
    let record: RecentDestinationRecord
    let onSelect: () -> Void

    var body: some View {
        DestinationLocationRow(
            title: record.destination.name,
            subtitle: record.destination.subtitle,
            action: onSelect
        )
    }
}
