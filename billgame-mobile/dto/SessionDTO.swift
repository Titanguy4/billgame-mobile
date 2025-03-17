struct SessionDTO: Codable {
    var uuid: String?
    var adresse: String
    var startDepositDate: String
    var endDepositDate: String
    var startSellDate: String
    var endSellDate: String
    var depositFees: Double
    var areDepositFeesPercentage: Bool
    var commission: Double
    var isCommissionPercentage: Bool
}
