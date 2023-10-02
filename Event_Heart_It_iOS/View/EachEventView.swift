//
//  EachEventView.swift
//  Event_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 2/10/2023.
//

import SwiftUI

struct EachEventView: View {
    let event: EventData

    var body: some View {
        // Use the 'event' data to render the details in this view
        Text("Event Name: \(event.name)")
            .padding()
    }
}
