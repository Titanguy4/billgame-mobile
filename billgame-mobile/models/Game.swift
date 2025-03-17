class Game {

    private var _etiquette: String
    private var _name: String
    private var _editor: String
    private var _price: Double

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

    static func fromDTO(_ dto: SingleStockDTO) -> Game {
        return Game(
            etiquette: dto.label,
            name: dto.game_name,
            editor: dto.editor_name,
            price: dto.price
        )
    }
}

