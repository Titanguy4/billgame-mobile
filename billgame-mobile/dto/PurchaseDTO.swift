/// `PurchaseDTO` est une structure de transfert de données (DTO) utilisée pour représenter un achat.
struct PurchaseDTO: Codable {
    let editInvoice: Bool
    let buyerUuuid: String?
    let stockLabel: [String]
    let paymentMethode: String // Cash ou Credit Card
}
