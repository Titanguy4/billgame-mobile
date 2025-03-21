import Foundation

@MainActor
class DepotViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isEmailValid: Bool = false
    @Published var isEmailVerified: Bool = false
    @Published var errorMessage: String?
    @Published var merchantUUID: String?

    private let userService: UserService = UserService()

    func validateEmail() {
        isEmailValid = isValidEmail(email)
        if isEmailValid {
            Task {
                await checkMerchantEmail()
            }
        } else {
            errorMessage = "Format d'email incorrect."
            isEmailVerified = false
        }
    }

    func checkMerchantEmail() async {
        do {
            let uuid = try await userService.getMerchantUUIDByEmail(email: email)
            self.merchantUUID = uuid
            self.isEmailVerified = true
            self.errorMessage = nil
        } catch {
            if let urlError = error as? URLError, urlError.code == .badServerResponse {
                self.errorMessage = "L'email du vendeur est incorrect."
            } else {
                self.errorMessage = "Problème avec le serveur"
            }
            self.isEmailVerified = false
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
