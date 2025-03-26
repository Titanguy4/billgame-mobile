import Foundation

/// `StockService` gère la communication avec l'API pour effectuer des actions liées aux stocks de jeux.
class StockService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr/stock"
    private let httpService: HttpService = HttpService()

    /// Recherche un jeu par son étiquette et renvoie un résultat.
    /// - Parameters:
    ///   - etiquette: L'étiquette du jeu à rechercher.
    ///   - completion: Un callback qui renvoie un `Result` avec un objet `SingleStockDTO` ou une erreur.
    func findGameByEtiquette(etiquette: String, completion: @escaping (Result<SingleStockDTO, ErrorApi>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/\(etiquette)?active=true") else {
            completion(.failure(.invalidURL))
            return
        }

        httpService.get(url: url, success: { data, _ in
            do {
                let game = try JSONDecoder().decode(SingleStockDTO.self, from: data)
                completion(.success(game))
            } catch {
                completion(.failure(.decodingError))
            }
        }, failure: { error in
            completion(.failure(.unknownError(error)))
        })
    }

    /// Poste un dépôt de jeu, et renvoie le montant en retour.
    /// - Parameters:
    ///   - deposit: L'objet `DepositDTO` contenant les informations du dépôt.
    ///   - publish: Un booléen qui indique si le dépôt doit être publié.
    ///   - completion: Un callback qui renvoie un `Result` avec le montant du dépôt ou une erreur.
    func postDeposit(deposit: DepositDTO, publish: Bool, completion: @escaping (Result<Double, ErrorApi>) -> Void) {
        
        guard let url = URL(string: "\(baseUrl)/deposit?publish=\(publish)") else {
            completion(.failure(.invalidURL))
            return
        }

        do {
            let body = try JSONEncoder().encode(deposit)
            httpService.post(url: url, body: body, success: { data, _ in
                do {
                    let response = try JSONDecoder().decode(Double.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Erreur de décodage:", error)
                    print("Données reçues:", String(data: data, encoding: .utf8) ?? "Aucune donnée")
                    completion(.failure(.decodingError))
                }
            }, failure: { error in
                print("Erreur HTTP:", error)
                completion(.failure(.unknownError(error)))
            })

        } catch {
            completion(.failure(.decodingError))
        }
    }

    /// Récupère la liste des stocks disponibles.
    /// - Parameter completion: Un callback qui renvoie un `Result` avec une liste d'objets `StockDTO` ou une erreur.
    func getAvailableStock(completion: @escaping (Result<[StockDTO], ErrorApi>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(.failure(.invalidURL))
            return
        }

        httpService.get(url: url, success: { data, _ in
            do {
                let stockList = try JSONDecoder().decode([StockDTO].self, from: data)
                completion(.success(stockList))
            } catch {
                completion(.failure(.decodingError))
            }
        }, failure: { error in
            completion(.failure(.unknownError(error)))
        })
    }

    /// Retire une liste de jeux du stock.
    /// - Parameters:
    ///   - listOfGamesToWithdraw: L'objet `WithdrawGamesDTO` contenant les jeux à retirer.
    ///   - completion: Un callback qui renvoie un `Result` avec `Void` ou une erreur.
    func withdrawGames(listOfGamesToWithdraw: WithdrawGamesDTO, completion: @escaping (Result<Void, ErrorApi>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/withdraw") else {
            completion(.failure(.invalidURL))
            return
        }

        do {
            print(listOfGamesToWithdraw)
            let body = try JSONEncoder().encode(listOfGamesToWithdraw)
            httpService.post(url: url, body: body, success: { response, _ in
                completion(.success(()))
            }, failure: { error in
                completion(.failure(.unknownError(error)))
            })
        } catch {
            completion(.failure(.decodingError))
        }
    }

    /// Récupère la liste des jeux disponibles pour un vendeur spécifique.
    /// - Parameters:
    ///   - sellerUuid: L'UUID du vendeur.
    ///   - completion: Un callback qui renvoie un `Result` avec une liste de `SingleStockDTO` ou une erreur.
    func getAvailableStockForSeller(sellerUuid: String, completion: @escaping (Result<[SingleStockDTO], ErrorApi>) -> Void) {
            guard let url = URL(string: "\(baseUrl)/current-session/\(sellerUuid)/active/on-sale") else {
                completion(.failure(.invalidURL))
                return
            }

            httpService.get(url: url, success: { data, _ in
                do {
                    let stockList = try JSONDecoder().decode([SingleStockDTO].self, from: data)
                    completion(.success(stockList))
                } catch {
                    completion(.failure(.decodingError))
                }
            }, failure: { error in
                completion(.failure(.unknownError(error)))
            })
        }

    /// Récupère la liste des jeux vendus par un vendeur spécifique.
    /// - Parameters:
    ///   - sellerUuid: L'UUID du vendeur.
    ///   - completion: Un callback qui renvoie un `Result` avec une liste de `SingleStockDTO` ou une erreur.
    func getSoldGamesForSeller(sellerUuid: String, completion: @escaping (Result<[SingleStockDTO], ErrorApi>) -> Void) {
            guard let url = URL(string: "\(baseUrl)/current-session/\(sellerUuid)/active/sold") else {
                completion(.failure(.invalidURL))
                return
            }

            httpService.get(url: url, success: { data, _ in
                do {
                    let soldGames = try JSONDecoder().decode([SingleStockDTO].self, from: data)
                    completion(.success(soldGames))
                } catch {
                    completion(.failure(.decodingError))
                }
            }, failure: { error in
                completion(.failure(.unknownError(error)))
            })
        }
}
