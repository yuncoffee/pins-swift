//
//  AppleSignInView.swift
//  pins
//
//  Created by yuncoffee on 12/18/23.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInView: View {
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
    AppleSignInView()
}

extension AppleSignInView {
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
