import Foundation

class StockService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr/stock"
    private let httpService: HttpService = HttpService()

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

    func withdrawGames(listOfGamesToWithdraw: WithdrawGamesDTO, completion: @escaping (Result<Void, ErrorApi>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/withdraw") else {
            completion(.failure(.invalidURL))
            return
        }

        do {
            let body = try JSONEncoder().encode(listOfGamesToWithdraw)
            httpService.post(url: url, body: body, success: { _, _ in
                completion(.success(()))
            }, failure: { error in
                completion(.failure(.unknownError(error)))
            })
        } catch {
            completion(.failure(.decodingError))
        }
    }
    
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
