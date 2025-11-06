//
//  SignUpViewModel.swift
//  mood_capture
//
//  Created by MacBook on 06/11/24.
//

import Foundation
import FirebaseAuth

class SignUpViewModel: ObservableObject{
    
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isUserSignUp: Bool?
    
    func signUp(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle errors like invalid email or weak password
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            DispatchQueue.main.async {
                self.isUserSignUp = true
            }
            
            // Successfully created user
//            self.showAlert(message: "Signup successful!")
        }
    }
}
