/// `SingleStockDTO` est une structure de transfert de données (DTO) utilisée pour représenter un stock individuel.
struct SingleStockDTO: Codable {
    let label: String
    let editor_name: String
    let game_name: String
    let price: Double
    let owner_uuid: String
}
