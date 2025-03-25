/// `TransacDepositDTO` est une structure de transfert de données (DTO) utilisée pour représenter une transaction de dépôt.
struct TransacDepositDTO: Codable {
    let depotId: Int
    let priceOfDeposit: Double
    let paymentMethod: String
}
