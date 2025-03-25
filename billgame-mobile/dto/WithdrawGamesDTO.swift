/// `WithdrawGamesDTO` est une structure de transfert de données (DTO) utilisée pour représenter une demande de retrait de jeux.
struct WithdrawGamesDTO: Codable {
    let ownerUuid: String
    let labels: [String]
}
