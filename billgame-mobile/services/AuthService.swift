import Foundation
import Security
import JWTDecode
import SwiftUI

struct AuthJwtPayload: Codable {
    let roles: [String]
    let uuid: String
    let name: String
    let sub: String
    let exp: TimeInterval
    let iat: TimeInterval
}

class AuthService {
    
    private var role: [String] = []
    private var authTokenStore: AuthTokenStore = AuthTokenStore()
    
    var isManager: Bool = false
    var isAdmin: Bool = false
    var isMerchant: Bool = false

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

    func getUuid() -> String? {
        guard let token = authTokenStore.token, let jwt = try? decode(jwt: token) else { return nil }
        return jwt.claim(name: "uuid").string
    }

    func getName() -> String? {
        guard let token = authTokenStore.token, let jwt = try? decode(jwt: token) else { return nil }
        return jwt.claim(name: "name").string
    }

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
