/// `DepositDTO` est une structure de transfert de données (DTO) utilisée pour représenter un dépôt de produits.
struct DepositDTO: Codable {
    let uuidSeller: String
    let stocks: [StockDTO]
    let paymentMethod: String
    let isPublished: Bool
}
