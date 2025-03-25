/// `StockDTO` est une structure de transfert de données (DTO) utilisée pour représenter un stock de jeu.
struct StockDTO: Codable {
    let editor_name: String
    let game_name: String
    let price: Double
    let quantity: Int
    let owner_uuid: String
}
