/// `Game` est une classe représentant un jeu vidéo avec des informations essentielles comme le nom, l'éditeur, le prix et une étiquette.
class Game: Identifiable {

    private var _etiquette: String
    private var _name: String
    private var _editor: String
    private var _price: Double

    /// Initialiseur pour créer une instance de `Game` avec les valeurs fournies.
    /// - Parameters:
    ///   - etiquette: L'étiquette du jeu.
    ///   - name: Le nom du jeu.
    ///   - editor: L'éditeur du jeu.
    ///   - price: Le prix du jeu.
    init(etiquette: String, name: String, editor: String, price: Double) {
        self._etiquette = etiquette
        self._name = name
        self._editor = editor
        self._price = price
    }

    var name: String {
        get { return _name }
        set { _name = newValue }
    }

    var editor: String {
        get { return _editor }
        set { _editor = newValue }
    }

    var price: Double {
        get { return _price }
        set { _price = newValue }
    }

    var etiquette: String {
        return _etiquette
    }

    /// Fonction statique qui crée une instance de `Game` à partir d'un objet `SingleStockDTO`.
    /// - Parameter dto: L'objet `SingleStockDTO` contenant les informations du jeu.
    /// - Returns: Une instance de `Game` correspondante.
    static func fromDTO(_ dto: SingleStockDTO) -> Game {
        return Game(
            etiquette: dto.label,
            name: dto.game_name,
            editor: dto.editor_name,
            price: dto.price
        )
    }
}
