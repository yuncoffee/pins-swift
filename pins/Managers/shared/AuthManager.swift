//
//  AuthManager.swift
//  pins
//
//  Created by yuncoffee on 12/18/23.
//

import Foundation
import Combine
import Observation
import FirebaseAuth

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@Observable
@MainActor
final class AuthManager {
    /// 사용자의 로그인 이메일
    var email = "" {
        didSet {
            if email.isEmpty {
                updateInvalidStatus()
            }
        }
    }
    /// 사용자의 로그인 패스워드
    var password = "" {
        didSet {
            updateInvalidStatus()
        }
    }
    /// 사용자의 패스워드 확인
    var confirmPassword = "" {
        didSet {
            updateInvalidStatus()
        }
    }
    /// 인증 절차
    var flow: AuthenticationFlow = .login
    /// 잘못된 정보 체크
    var isValid  = false
    /// 인증 상태
    var authenticationState: AuthenticationState = .unauthenticated
    var errorMessage = ""
    /// FirebaseAuth User 정보
    var user: User?
    /// 화면에 표시할 이름
    var displayName = ""
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        registerAuthStateHandler()
    }
    
}

extension AuthManager {
    // 앱 실행 시 상태 체크
    private func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            }
        }
    }
    
    private func updateInvalidStatus() {
        isValid = flow == .login
        ? !(email.isEmpty || password.isEmpty)
        : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
    }
}

extension AuthManager {
    public func switchFlow() {
      flow = flow == .login ? .signUp : .login
      errorMessage = ""
    }
    /// 로그인 필드 초기화 및  상태 변경
    public func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
}

// MARK: - Email and Password Authentication

extension AuthManager {
    /// 로그인
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            return true
        }
        catch  {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    /// 회원가입
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do  {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    /// 로그아웃
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    /// 계정삭제
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
