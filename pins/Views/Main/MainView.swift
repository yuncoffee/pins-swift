//
//  MainView.swift
//  pins
//
//  Created by yuncoffee on 12/13/23.
//

import SwiftUI
import MapKit

struct MainView: View {
    @Environment(AuthManager.self)
    var authManager
    
    @State
    private var visibleRegion: MKCoordinateRegion?
    
    @State
    private var position: MapCameraPosition = .automatic
    
    @State
    private var searchResults: [SearchResult] = []
    @State
    private var selectedLocation: SearchResult?
    
    @State
    private var isSheetActive = true
    
    @State
    var selectedDetent: PresentationDetent = .min
    
    private let screenHeight = UIScreen.main.bounds.size.height
    private let availableDetents: Set<PresentationDetent> = [.min, .medium, .large]
    
    var body: some View {
        Map(position: $position, selection: $selectedLocation) {
            Marker("House", systemImage: "house.fill", coordinate: .devHouse)
                .annotationTitles(.hidden)
            ForEach(searchResults, id: \.self) { result in
                Marker(coordinate: result.location) {
                    Image(systemName: "mappin")
                }
            }
            UserAnnotation()
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
                .buttonBorderShape(.circle)
            MapScaleView()
            MapPitchToggle()
                .buttonBorderShape(.circle)
            MapCompass()
        }
        .animation(.default, value: selectedDetent)
        .safeAreaInset(edge: .bottom) {
            //            MapControlView(searchResults: $searchResults, visibleRegion: $visibleRegion)
            //                .padding(.horizontal, 16)
            //                .frame(maxWidth: .infinity, alignment: .trailing)
            //                .offset(y: selectedDetent == .min ? -(56 + 8) : -((screenHeight / 2) + 8))
            //                .border(.red)
//            if selectedLocation != nil {
//                LookAroundPreview(scene: $scene, allowsNavigation: false, badgePosition: .bottomTrailing)
//                    .frame(height: 150)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                    .safeAreaPadding(.bottom, 40)
//                    .padding(.horizontal, 20)
//            }
        }
        .sheet(isPresented: $isSheetActive) {
            MapSheetView(searchResults: $searchResults)
                .presentationBackground(.regularMaterial)
                .presentationDetents(availableDetents, selection: $selectedDetent)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .interactiveDismissDisabled()
            
        }
        .onAppear {
            position = .userLocation(fallback: .automatic)
        }
        .onChange(of: selectedLocation) {
            print(selectedLocation?.location)
//            isSheetActive = selectedLocation == nil
        }
        .onChange(of: searchResults) {
            print(searchResults.count)
//            position = .automatic
            if let firstResult = searchResults.first, searchResults.count == 1 {
                selectedLocation = firstResult
            }
        }
    }
    
    private func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene? {
           let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
           return try await lookAroundScene.scene
       }
}

extension MainView {
    
}

#Preview {
    MainView()
        .environment(AuthManager())
}

extension PresentationDetent {
    static let min = Self.height(56)
}
