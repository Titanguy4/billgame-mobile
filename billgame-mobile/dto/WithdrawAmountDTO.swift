/// `WithdrawAmountDTO` est une structure de transfert de données (DTO) utilisée pour représenter une demande de retrait d'un montant.
struct WithdrawAmountDTO: Codable {
    let sellerUuid: String
    let amount: Double
    let paymentMethod: String
}
