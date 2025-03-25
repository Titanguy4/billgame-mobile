/// `GameDTO` est une structure de transfert de données (DTO) utilisée pour représenter un jeu vidéo.
struct GameDTO: Codable {
    let id: Int
    let name: String
    let editor: String
}
