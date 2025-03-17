class GameWithStock {
    
    // Propriétés -----------------------------------------
    let name: String
    let editor: String
    let price: Double
    private var _stock: Int
    private let owner_uuid: String

    // Initialisateur -------------------------------------
    init(name: String, editor: String, price: Double, stock: Int, owner_uuid: String) {
        self.name = name
        self.editor = editor
        self.price = price
        self._stock = stock
        self.owner_uuid = owner_uuid
    }

    // Getter et Setter -----------------------------------
    var stock: Int {
        get { return _stock }
        set { _stock = newValue }
    }

    // Conversion en DTO ----------------------------------
    func toDTO() -> StockDTO {
        return StockDTO(
            editor_name: editor,
            game_name: name,
            price: price,
            quantity: stock,
            owner_uuid: owner_uuid
        )
    }

    // Création à partir d’un DTO -------------------------
    static func fromDTO(_ dto: StockDTO) -> GameWithStock {
        return GameWithStock(
            name: dto.game_name,
            editor: dto.editor_name,
            price: dto.price,
            stock: dto.quantity,
            owner_uuid: dto.owner_uuid
        )
    }
}
