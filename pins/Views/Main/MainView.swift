//
//  MainView.swift
//  pins
//
//  Created by yuncoffee on 12/13/23.
//

import SwiftUI
import MapKit

struct MainView: View {
    @Environment(\.safeAreaInsets)
    var safeAreaInsets
    @Environment(AuthManager.self)
    var authManager
    
    @State
    private var region = MKCoordinateRegion(center: .devHouse, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
  
    @State
    private var visibleRegion: MKCoordinateRegion?
    
    @State
    private var position: MapCameraPosition = .automatic
    
    @State
    private var searchResults: [MKMapItem] = []
    
    @State
    private var selectedResult: MKMapItem? {
        didSet {
            print(selectedResult?.name)
        }
    }
    
    @State
    private var isSheetActive = true

    @State var selectedDetent: PresentationDetent = .min

    private let screenHeight = UIScreen.main.bounds.size.height
    private let availableDetents: Set<PresentationDetent> = [.min, .medium, .large]
    
    var body: some View {
        Map(position: $position, selection: $selectedResult) {
            Marker("House", systemImage: "house.fill", coordinate: .devHouse)
                .tint(.mint)
//            Annotation("House2", coordinate: .devHouse2) {
//                Image(systemName: "car.fill")
//                    .padding()
//                    .foregroundStyle(.white)
//                    .background(Color.green)
//                    .clipShape(Circle())
//            }
            .annotationTitles(.hidden)
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
                    .tag(result)
            }
            UserAnnotation()
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
                .buttonBorderShape(.circle)
            MapScaleView()
                .mapControlVisibility(.automatic)
            MapPitchToggle()
                .buttonBorderShape(.circle)
                .mapControlVisibility(.automatic)
            MapCompass()
                .mapControlVisibility(.automatic)
        }
//        .safeAreaPadding(.bottom, 16)
//        .safeAreaInset(edge: .bottom) {
//            MapControlView(searchResults: $searchResults, visibleRegion: $visibleRegion)
//                .padding(.horizontal, 16)
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .offset(y: selectedDetent == .min ? -(56 + 8) : -((screenHeight / 2) + 8))
//                .border(.red)
//        }
//        .onAppear {
//            position = .userLocation(fallback: .automatic)
//        }
        .onChange(of: searchResults) {
            position = .automatic
        }
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
//        .animation(.default, value: selectedDetent)
//        .sheet(isPresented: $isSheetActive, onDismiss: didDismiss) {
//            VStack {
//                Text("Hello, World!")
//                Button {
//                    authManager.signOut()
//                } label: {
//                    Text("로그아웃")
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .border(.blue)
//            .presentationDetents(availableDetents, selection: $selectedDetent)
//            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
//            .interactiveDismissDisabled()
//            .ignoresSafeArea()
//        }
    }
    
    func didDismiss() {
        // Handle the dismissing action.
        isSheetActive = true
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
