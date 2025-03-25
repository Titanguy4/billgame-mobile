/// `GameWithStock` est une classe représentant un jeu vidéo avec des informations sur son stock. Elle comprend également un identifiant unique.
class GameWithStock: Identifiable {
    
    let name: String
    let editor: String
    let price: Double
    private var _stock: Int
    private let owner_uuid: String

    /// Initialiseur pour créer une instance de `GameWithStock` avec les informations fournies.
    /// - Parameters:
    ///   - name: Le nom du jeu.
    ///   - editor: L'éditeur du jeu.
    ///   - price: Le prix du jeu.
    ///   - stock: La quantité en stock du jeu.
    ///   - owner_uuid: L'identifiant unique du propriétaire du jeu.
    init(name: String, editor: String, price: Double, stock: Int, owner_uuid: String) {
        self.name = name
        self.editor = editor
        self.price = price
        self._stock = stock
        self.owner_uuid = owner_uuid
    }

    var stock: Int {
        get { return _stock }
        set { _stock = newValue }
    }

    /// Fonction pour convertir un objet `GameWithStock` en un objet `StockDTO` pour le transfert de données.
    /// - Returns: Un objet `StockDTO` représentant les données du jeu.
    func toDTO() -> StockDTO {
        return StockDTO(
            editor_name: editor,
            game_name: name,
            price: price,
            quantity: stock,
            owner_uuid: owner_uuid
        )
    }

    /// Fonction statique pour créer une instance de `GameWithStock` à partir d'un objet `StockDTO`.
    /// - Parameter dto: L'objet `StockDTO` contenant les informations du jeu.
    /// - Returns: Une instance de `GameWithStock` correspondante.
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
