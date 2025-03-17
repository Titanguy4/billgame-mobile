import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = "diane.dubois@example.com"
    @Published var password: String = "hashed_password_diane"
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String? = nil

    private let authService = AuthService()

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email et mot de passe requis."
            return
        }

        authService.login(email: email, password: password) { [weak self] success,errorMessage  in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                    
                } else {
                    self?.errorMessage = errorMessage
                }
            }
        }
    }
    
    func logout() {
        authService.logout()
    }
}
