import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated: Bool = false
    @Published var roles: [String] = []
    
    private let authService = AuthService()

    init() {}

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email et mot de passe requis."
            return
        }

        authService.login(email: email, password: password) { [weak self] success, message in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if success {
                    self.isAuthenticated = true
                    self.errorMessage = nil
                } else {
                    self.errorMessage = message
                }
            }
        }
    }
    
    func logout() {
        authService.logout()
        isAuthenticated = false
        roles = []
    }

    var isAdmin: Bool {
        self.authService.isAdmin
    }
    
    var isManager: Bool {
        self.authService.isManager
    }
    
    var isMerchant: Bool {
        self.authService.isMerchant
    }
}
