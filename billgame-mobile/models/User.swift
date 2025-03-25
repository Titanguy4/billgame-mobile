import SwiftUI

/// `User` est une structure représentant un utilisateur avec des informations de base comme l'identifiant, le nom, l'email, le téléphone et le rôle.
struct User : Codable, Identifiable {
    let id : String
    var name: String
    var email: String
    var phone: String
    var role: String
    
    /// Initialiseur pour créer un objet `User` avec les valeurs fournies.
    /// - Parameters:
    ///   - id: L'identifiant unique de l'utilisateur.
    ///   - name: Le nom de l'utilisateur.
    ///   - email: L'email de l'utilisateur.
    ///   - phone: Le numéro de téléphone de l'utilisateur.
    ///   - role: Le rôle de l'utilisateur
    init(id: String, name: String, email : String, phone : String, role: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.role = role
    }
    
    /// Initialiseur pour créer un objet `User` à partir d'un objet `UserDTO`.
    /// - Parameter dto: L'objet `UserDTO` à partir duquel créer l'instance de `User`.
    init(from dto: UserDTO) {
        self.id = dto.uuid
        self.name = dto.name
        self.email = dto.email
        self.phone = dto.phone
        self.role = dto.roles.first ?? "User"  // Valeur par défaut "User" si aucun rôle n'est spécifié
    }
    
    /// Fonction pour convertir l'objet `User` en un objet `UserDTO`.
    /// - Returns: Un objet `UserDTO` contenant les informations de l'utilisateur.
    func toDTO() -> UserDTO {
        return UserDTO(
            uuid: self.id,
            name: self.name,
            email: self.email,
            phone: self.phone,
            roles: [self.role],
            password: nil,
            adress: nil
        )
    }
}
