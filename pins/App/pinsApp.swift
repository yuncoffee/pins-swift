//
//  pinsApp.swift
//  pins
//
//  Created by yuncoffee on 12/13/23.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseCore
import FirebaseAuth

@main
struct pinsApp: App {
    @AppStorage("auth_token") var authToken: String?
    
    @State
    var authManager: AuthManager
    
    init() {
        FirebaseApp.configure()
        authManager = AuthManager()
//        Auth.auth().useEmulator(withHost:"localhost", port:9099)
    }
    
    // MARK: swiftdata 처리할 때 살리기
    //    var sharedModelContainer: ModelContainer = {
    //        let schema = Schema([
    //            Item.self,
    //        ])
    //        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    //
    //        do {
    //            return try ModelContainer(for: schema, configurations: [modelConfiguration])
    //        } catch {
    //            fatalError("Could not create ModelContainer: \(error)")
    //        }
    //    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
        }
        //        .modelContainer(sharedModelContainer)
    }
}