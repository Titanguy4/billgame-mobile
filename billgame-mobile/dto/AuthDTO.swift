/// `AuthDTO` est une structure de transfert de données (DTO) utilisée pour l'authentification (login)
struct AuthDTO: Codable {
    let email: String
    let password: String
}
