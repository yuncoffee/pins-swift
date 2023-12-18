//
//  ContentView.swift
//  pins
//
//  Created by yuncoffee on 12/13/23.
//

import SwiftUI
//import SwiftData
import AuthenticationServices

struct AppleUser: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard let firstName = credentials.fullName?.givenName,
              let lastName = credentials.fullName?.familyName,
              let email = credentials.email
        else { return nil }
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) 
    var colorScheme
    
    @AppStorage("userId")
    var userID: String?
    
    var body: some View {
        VStack(spacing: .zero) {
            Text("Hello World!")
            if userID != nil {
                Text("SignedIn")
            }
            SignInWithAppleButton(
                .signIn, onRequest:
                    signInWithAppleConfig,
                onCompletion: signInWithAppleCompletion
            )
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(height: 44)
            .padding()
        }
        .onAppear(perform: {
        })
    }
}

#Preview {
    ContentView()
}

extension ContentView {
    func signInWithAppleConfig(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func signInWithAppleCompletion(_ authResult: Result<ASAuthorization, Error>) {
        switch authResult {
        case .success(let authorization):
            switch authorization.credential {
            case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                if let appleUser = AppleUser(credentials: appleIdCredentials),
                    let appleUserData = try? JSONEncoder().encode(appleUser) {
                    UserDefaults.standard.setValue(appleUser.userId, forKey: "userId")
                    UserDefaults.standard.setValue(appleUserData, forKey: appleUser.userId)
                    #if DEBUG
                    print("Saved apple User", appleUser)
                    #endif
                } else {
                    print("Missing some fileds", appleIdCredentials.email, appleIdCredentials.fullName, appleIdCredentials.user)
                    guard let appleUserData = UserDefaults.standard.data(forKey: appleIdCredentials.user),
                          let appleUser = try? JSONDecoder().decode(AppleUser.self, from: appleUserData)
                    else { return }
                    
                    print(appleUser)
                }
            default:
                print(authorization.credential)
            }
            // Handle authorization
            break
        case .failure(let error):
            print("fail: \(error.localizedDescription)")
            // Handle error
            break
        }
    }
}
