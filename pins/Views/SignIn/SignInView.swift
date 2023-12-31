//
//  SignInView.swift
//  pins
//
//  Created by yuncoffee on 12/13/23.
//

import SwiftUI
import FirebaseAnalyticsSwift

private enum FocusableField: Hashable {
    case email
    case password
}

struct SignInView: View {
    @Environment(AuthManager.self)
    private var authManager
    @Environment(\.dismiss)
    var dismiss
    
    @FocusState
    private var focus: FocusableField?
    
    var body: some View {
        @Bindable var authManager = authManager
        VStack {
            HStack {
                Image(systemName: "at")
                TextField("Email", text: $authManager.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 4)
            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $authManager.password)
                    .focused($focus, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        signInWithEmailPassword()
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            if !authManager.errorMessage.isEmpty {
                VStack {
                    Text(authManager.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                }
            }
            Button(action: signInWithEmailPassword) {
                if authManager.authenticationState != .authenticating {
                    Text("Login")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(!authManager.isValid)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            HStack {
                Text("Don't have an account yet?")
                Button {
                    authManager.switchFlow()
                } label: {
                    Text("Sign up")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            .padding([.top, .bottom], 50)
        }
        .listStyle(.plain)
        .padding()
    }
}

extension SignInView {
    private func signInWithEmailPassword() {
        Task {
            if await authManager.signInWithEmailPassword() == true {
                dismiss()
            }
        }
    }
}

#Preview {
    SignInView()
}

extension SignInView {
    final class SignInViewModel {
        
    }
}
