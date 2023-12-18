//
//  EmailSignInView.swift
//  pins
//
//  Created by yuncoffee on 12/18/23.
//

import SwiftUI

struct EmailSignInView: View {
    enum Field: Hashable {
        case username
        case password
    }
    
    @State private var username = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("SIGN IN")) {
                    TextField("Email", text: $username)
                        .focused($focusedField, equals: .username)
                    SecureField("Password", text: $password)
                        .focused($focusedField, equals: .password)
                }
                Button {
                    if username.isEmpty {
                        focusedField = .username
                    } else if password.isEmpty {
                        focusedField = .password
                    } else {
                        handleLogin(username, password)
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Sign In")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("로그인")
    }
}

extension EmailSignInView {
    private func handleLogin(_ username: String, _ password: String) {
        print(username, password)
    }
}

#Preview {
    EmailSignInView()
}
