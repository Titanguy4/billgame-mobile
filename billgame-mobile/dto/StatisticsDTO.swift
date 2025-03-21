struct StatisticsDTO: Codable {
    let tresorerieTotal: Double
    let dueToVendor: Double
    let depositFeeCollected: Double
    let commissionFeeCollected: Double
    let amountWithdrawn: Double
    let numberOfSell: Int?
    let numberOfDeposit: Int?
    let numberOfNotSoldGames: Int?
    let numberOfWithrawnGames: Int?
}
