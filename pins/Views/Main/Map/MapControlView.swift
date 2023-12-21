//
//  MapControlView.swift
//  pins
//
//  Created by yuncoffee on 12/19/23.
//

import SwiftUI
import MapKit

struct MapControlView: View {
    @Binding
    var searchResults: [MKMapItem]
    @Binding
    var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        HStack {
            Button {
                search(for: "park")
            } label: {
                Label("Playgrounds", systemImage: "figure.and.child.holdinghands")
            }
            .buttonStyle(.borderedProminent)
            Button {
                search(for: "coffee shop")
            } label: {
                Label("ParK", systemImage: "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
            Button {
                search(for: "coffee")
            } label: {
                Label("ParK", systemImage: "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
        }
        .labelStyle(.iconOnly)
    }
}

extension MapControlView {
    private func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: .devHouse,
            span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        )
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
}

#Preview {
    @State 
    var searchResults: [MKMapItem] = []
    @State
    var visibleRegion: MKCoordinateRegion?
    
    return MapControlView(searchResults: $searchResults, visibleRegion: $visibleRegion)
}
