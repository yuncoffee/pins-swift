//
//  OnboardingView.swift
//  pins
//
//  Created by yuncoffee on 12/18/23.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(AuthManager.self)
    private var authManager
    @Environment(ContentView.ContentVM.self)
    private var contentVM
    
    var body: some View {
        VStack {
            Text("U Need Sign In")
            Button {
                authManager.reset()
                contentVM.presentingLoginScreen.toggle()
            } label: {
                Text("Tap here to Log In")
            }
        }
    }
}

#Preview {
    OnboardingView()
}
