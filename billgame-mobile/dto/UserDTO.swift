struct UserDTO: Codable {
    let uuid: String
    let name: String
    let email: String
    let phone: String
    let roles: [String]
    let password: String?
    let address: String?
}
