struct DepositDTO: Codable {
    let uuidSeller: String
    let stocks: [StockDTO]
    let paymentMethod: String
    let isPublished: Bool
}
