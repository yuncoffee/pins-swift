//
//  ContentView.swift
//  pins
//
//  Created by yuncoffee on 12/13/23.
//

import SwiftUI
//import SwiftData

struct ContentView: View {
    @Environment(AuthManager.self)
    private var authManager
    @State
    var vm = ContentVM()
    
    
    var body: some View {
        NavigationStack {
            @Bindable var vm = vm
            NavigationView {
                switch authManager.authenticationState {
                case .unauthenticated, .authenticating:
                    OnboardingView()
                        .environment(vm)
                        .sheet(isPresented: $vm.presentingLoginScreen) {
                            VStack {
                                switch authManager.flow {
                                case .login:
                                    SignInView()
                                case .signUp:
                                    SignUpView()
                                }
                            }
                        }
                case .authenticated:
                    MainView()
                        .environment(vm)
                }
            }
        }
    }
}

extension ContentView {
    @Observable
    final class ContentVM {
        var presentingLoginScreen = false
        var presentingProfileScreen = false
    }
}

#Preview {
    ContentView()
}

