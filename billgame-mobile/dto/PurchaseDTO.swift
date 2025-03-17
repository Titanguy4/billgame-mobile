struct PurchaseDTO: Codable {
    let editInvoice: Bool
    let buyerUuuid: String
    let stockLabel: [String]
    let paymentMethode: String
}
