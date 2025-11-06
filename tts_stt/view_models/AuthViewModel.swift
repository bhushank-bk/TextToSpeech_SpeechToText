//
//  LoginViewModel.swift
//  mood_capture
//
//  Created by MacBook on 22/10/24.
//

import Foundation
import Firebase
import Combine
import FirebaseAuth
import UIKit


class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isUserSignIn: Bool?
    
    
    private var authManager: FirebaseAuthManager
    
    init(authManager: FirebaseAuthManager = FirebaseAuthManager()) {
        self.authManager = authManager
    }
    
    func signInWithGoogle(presentingViewController: UIViewController) {
        
        authManager.signInWithGoogle(presentingViewController: presentingViewController) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    print("success user")
                    print(user)
                    self?.user = user
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signOut() {
        authManager.signOut { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.user = nil
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            // Successfully signed in
            DispatchQueue.main.async {
                self.isUserSignIn = true
            }
            // Here, navigate to the next screen or update the UI
        }
    }
}


