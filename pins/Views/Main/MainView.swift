//
//  MainView.swift
//  pins
//
//  Created by yuncoffee on 12/13/23.
//

import SwiftUI

struct MainView: View {
    @Environment(AuthManager.self)
    var authManager
    
    var body: some View {
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

#Preview {
    MainView()
        .environment(AuthManager())
}
