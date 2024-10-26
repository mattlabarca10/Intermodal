// MapView.swift
// Intermodal
// Created by Matthew LaBarca on 10/26/24.

import Foundation
import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        VStack {
            Text("Intermodal")
            Map()
            Text("Breakdown")
                .padding(.bottom, 200)
        }

    }
}

#Preview {
    MapView()
}


/*

 */
