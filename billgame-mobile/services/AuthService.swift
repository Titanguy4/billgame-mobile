import Foundation
import Security
import JWTDecode
import SwiftUI

/// `AuthJwtPayload` est une structure représentant la charge utile du JWT (JSON Web Token), qui contient des informations sur l'utilisateur et ses rôles.
struct AuthJwtPayload: Codable {
    let roles: [String]
    let uuid: String
    let name: String
    let sub: String
    let exp: TimeInterval
    let iat: TimeInterval
}

/// `AuthService` est une classe responsable de la gestion de l'authentification de l'utilisateur.
/// Elle interagit avec le serveur pour se connecter, gérer les tokens JWT et déterminer les rôles de l'utilisateur.
class AuthService {
    
    private var role: [String] = []
    private var authTokenStore: AuthTokenStore = AuthTokenStore()
    
    var isManager: Bool = false
    var isAdmin: Bool = false
    var isMerchant: Bool = false

    /// Configure les rôles de l'utilisateur à partir du JWT.
    /// - Parameter jwt: Le JWT décodé qui contient les informations sur les rôles de l'utilisateur.
    private func setRole(from jwt: JWT) {
        if let roles = jwt.claim(name: "roles").array {
            self.role = roles
        } else {
            self.role = []
        }
        
        isManager = role.contains("Manager")
        isAdmin = role.contains("Admin")
        isMerchant = role.contains("Seller")
    }

    var isBearerExpired: Bool {
        guard let token = authTokenStore.token, let jwt = try? decode(jwt: token) else { return true }
        return jwt.expired
    }

    func logout() {
        role = []
        authTokenStore.token = nil
    }

    /// Récupère l'UUID de l'utilisateur à partir du JWT.
    /// - Returns: L'UUID de l'utilisateur si disponible, sinon `nil`.
    func getUuid() -> String? {
        guard let token = authTokenStore.token, let jwt = try? decode(jwt: token) else { return nil }
        return jwt.claim(name: "uuid").string
    }

    /// Récupère le nom de l'utilisateur à partir du JWT.
    /// - Returns: Le nom de l'utilisateur si disponible, sinon `nil`.
    func getName() -> String? {
        guard let token = authTokenStore.token, let jwt = try? decode(jwt: token) else { return nil }
        return jwt.claim(name: "name").string
    }

    /// Effectue une connexion en envoyant les identifiants à un serveur et en récupérant un token d'authentification.
    /// - Parameters:
    ///   - email: L'email de l'utilisateur.
    ///   - password: Le mot de passe de l'utilisateur.
    ///   - completion: Un callback qui indique si la connexion a réussi ou non, ainsi qu'un message.
    func login(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "https://billgameback.mathiaspuyfages.fr/auth/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, "Erreur avec le serveur lors de la connexion.")
                return
            }

            if let authHeader = httpResponse.allHeaderFields["Authorization"] as? String {
                let tokenParts = authHeader.components(separatedBy: " ")
                if tokenParts.count == 2, tokenParts[0] == "Bearer" {
                    let token = tokenParts[1]
                    
                    DispatchQueue.main.async {
                        if let jwt = try? decode(jwt: token) {
                            self.authTokenStore.token = token
                            self.setRole(from: jwt)
                        }
                        completion(true, "Succès de la connexion")
                    }
                }
            } else {
                completion(false, "Erreur de connexion, vérifier vos identifiants")
            }
        }.resume()
    }
}
