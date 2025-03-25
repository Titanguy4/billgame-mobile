import Foundation

/// `GameService` est une classe responsable de la gestion des requêtes liées aux jeux.
/// Elle interagit avec l'API du backend pour récupérer des informations sur les jeux, les stocks et les éditeurs.
class GameService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr" // URL de base de l'API
    private let httpService: HttpService // Service HTTP utilisé pour faire les requêtes réseau

    /// Initialisateur de la classe `GameService`.
    /// - Parameter httpService: Le service HTTP à utiliser pour les requêtes (par défaut, une instance de `HttpService` est utilisée).
    init(httpService: HttpService = HttpService()) {
        self.httpService = httpService
    }

    /// Recherche un jeu en fonction de son étiquette.
    /// - Parameter etiquette: L'étiquette du jeu à rechercher.
    /// - Returns: Un objet `SingleStockDTO` représentant le jeu si trouvé, sinon `nil`.
    func findGameByEtiquette(etiquette: String) async -> SingleStockDTO? {
        let urlString = "\(baseUrl)/stock/\(etiquette)?active=true"
        guard let url = URL(string: urlString) else { return nil }

        return await withCheckedContinuation { continuation in
            httpService.get(url: url, success: { data, _ in
                do {
                    let game = try JSONDecoder().decode(SingleStockDTO.self, from: data)
                    continuation.resume(returning: game)
                } catch {
                    print("❌ Erreur lors du décodage du jeu : \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                }
            }, failure: { error in
                print("❌ Erreur réseau : \(error.localizedDescription)")
                continuation.resume(returning: nil)
            })
        }
    }

    /// Récupère la liste des stocks disponibles.
    /// - Returns: Un tableau d'objets `GameWithStock` représentant les jeux avec leurs stocks, ou `nil` en cas d'erreur.
    func getAvailableStock() async -> [GameWithStock]? {
        guard let url = URL(string: "\(baseUrl)/stock") else { return nil }

        return await withCheckedContinuation { continuation in
            httpService.get(url: url, success: { data, _ in
                do {
                    let stockDTOs = try JSONDecoder().decode([StockDTO].self, from: data)
                    let gamesWithStock = stockDTOs.map { GameWithStock.fromDTO($0) }
                    continuation.resume(returning: gamesWithStock)
                } catch {
                    print("❌ Erreur lors du décodage du stock : \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                }
            }, failure: { error in
                print("❌ Erreur réseau : \(error.localizedDescription)")
                continuation.resume(returning: nil)
            })
        }
    }

    /// Récupère l'éditeur d'un jeu par son nom.
    /// - Parameter gameName: Le nom du jeu pour lequel récupérer l'éditeur.
    /// - Parameter completion: Un callback qui retourne l'éditeur sous forme de `EditorDTO` ou `nil` si une erreur se produit.
    func getEditorByGame(gameName: String, completion: @escaping (EditorDTO?) -> Void) {
        guard let url = URL(string: "\(baseUrl)/game/editor?game=\(gameName)") else {
            print("URL invalide")
            completion(nil)
            return
        }

        httpService.get(url: url, success: { data, _ in
            do {
                let editors = try JSONDecoder().decode([EditorDTO].self, from: data)
                completion(editors.first)
            } catch {
                print("Erreur de parsing JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }, failure: { error in
            print("Erreur lors de la requête: \(error.localizedDescription)")
            completion(nil)
        })
    }
}
