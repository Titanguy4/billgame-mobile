/// `SessionDTO` est une structure de transfert de données (DTO) utilisée pour représenter une session de vente ou de dépôt.
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
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case adresse
        case startDepositDate = "start_deposit_date"
        case endDepositDate = "end_deposit_date"
        case startSellDate = "start_sell_date"
        case endSellDate = "end_sell_date"
        case depositFees = "deposit_fees"
        case areDepositFeesPercentage = "are_deposit_fees_percentage"
        case commission
        case isCommissionPercentage = "is_commission_percentage"
    }
}
