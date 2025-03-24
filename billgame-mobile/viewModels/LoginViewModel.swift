import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = "diane.dubois@example.com"
    @Published var password: String = "hashed_password_diane"
    @Published var errorMessage: String? = nil

    private let authService = AuthService()
    private let authTokenStore = AuthTokenStore()

    var isAuthenticated: Bool {
        authTokenStore.token != nil // ✅ Vérifie si un token est stocké
    }

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email et mot de passe requis."
            return
        }

        authService.login(email: email, password: password) { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if success {
                    self.errorMessage = nil
                    self.objectWillChange.send() // ✅ Force la mise à jour de l'UI
                } else {
                    self.errorMessage = errorMessage
                }
            }
        }
    }
    
    func logout() {
        authService.logout()
        objectWillChange.send()
    }
}
