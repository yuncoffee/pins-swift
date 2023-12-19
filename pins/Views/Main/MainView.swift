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
    private var region = MKCoordinateRegion()
    
    var body: some View {
        ZStack {
            Map(){
                Marker(coordinate: .yangjuHome) {
                    Text("Home")
                }
            }
            .onAppear {
                let manager = CLLocationManager()
                manager.requestWhenInUseAuthorization()
                manager.startUpdatingLocation()
            }
            //            {
            //                Marker("San Francisco City Hall", coordinate: cityHallLocation)
            //                                    .tint(.orange)
            //            }
            VStack {
                Text("Hello, World!")
                Button {
                    authManager.signOut()
                } label: {
                    Text("로그아웃")
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environment(AuthManager())
}
