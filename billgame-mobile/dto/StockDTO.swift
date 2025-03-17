struct StockDTO: Codable {
    let editor_name: String
    let game_name: String
    let price: Double
    let quantity: Int
    let owner_uuid: String
}
