import Foundation

class GameService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr"
    private let httpService: HttpService

    init(httpService: HttpService = HttpService()) {
        self.httpService = httpService
    }

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
    
    func getEditorByGame(gameName: String, completion: @escaping (EditorDTO?) -> Void) {
        guard let url = URL(string: "\(baseUrl)/game/editor?game=\(gameName)") else {
            print("URL invalide")
            completion(nil)
            return
        }

        httpService.get(url: url, success: { data, _ in
            do {
                let editors = try JSONDecoder().decode([EditorDTO].self, from: data)
                completion(editors.first) // On retourne seulement le premier éditeur trouvé
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
