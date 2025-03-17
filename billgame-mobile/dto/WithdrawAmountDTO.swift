struct WithdrawAmountDTO: Codable {
    let sellerUuid: String
    let amount: Double
    let paymentMethod: String
}
