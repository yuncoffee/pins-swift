//
//  pinsApp.swift
//  pins
//
//  Created by yuncoffee on 12/13/23.
//

import SwiftUI
import SwiftData
@main
struct pinsApp: App {
    @AppStorage("auth_token") var authToken: String?
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
        }
        //        .modelContainer(sharedModelContainer)
    }
}
