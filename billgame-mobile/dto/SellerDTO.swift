/// `SellerDTO` est une structure de transfert de données (DTO) utilisée pour représenter un vendeur.
struct SellerDTO: Codable {
    let uuid: String
    let name: String
    let email: String
    let phone: String
    let roles: [String]
    let password: String?
    let discount: Double
}
