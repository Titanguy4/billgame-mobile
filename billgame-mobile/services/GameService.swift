import Foundation

class GameService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr/stock"

    init() {}

    func findGameByEtiquette(etiquette: String) async -> SingleStockDTO? {
        let urlString = "\(baseUrl)/\(etiquette)?active=true"
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur HTTP: \(response)")
                return nil
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            return try decoder.decode(SingleStockDTO.self, from: data)
        } catch {
            print("❌ Erreur lors de la récupération du jeu : \(error.localizedDescription)")
            return nil
        }
    }

    func postDeposit(deposit: DepositDTO, publish: Bool) async -> Int? {
        let urlString = "\(baseUrl)/deposit?publish=\(publish)"
        guard let url = URL(string: urlString) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(deposit)
            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.upload(for: request, from: jsonData)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur HTTP: \(response)")
                return nil
            }

            return try JSONDecoder().decode(Int.self, from: data)
        } catch {
            print("❌ Erreur lors de l'envoi du dépôt : \(error.localizedDescription)")
            return nil
        }
    }

    func getAvailableStock() async -> [GameWithStock]? {
        guard let url = URL(string: baseUrl) else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur HTTP: \(response)")
                return nil
            }
            
            let stockDTOs = try JSONDecoder().decode([StockDTO].self, from: data)
            print(stockDTOs)
            return stockDTOs.map { GameWithStock.fromDTO($0) }
        } catch {
            print("❌ Erreur lors de la récupération du stock : \(error.localizedDescription)")
            return nil
        }
    }

    func getAvailableStockForSeller(sellerUuid: String) async -> [SingleStockDTO]? {
        let urlString = "\(baseUrl)/current-session/\(sellerUuid)/active/on-sale"
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur HTTP: \(response)")
                return nil
            }

            return try JSONDecoder().decode([SingleStockDTO].self, from: data)
        } catch {
            print("❌ Erreur lors de la récupération du stock pour le vendeur : \(error.localizedDescription)")
            return nil
        }
    }

    func getSoldGamesForSeller(sellerUuid: String) async -> [SingleStockDTO]? {
        let urlString = "\(baseUrl)/current-session/\(sellerUuid)/active/sold"
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur HTTP: \(response)")
                return nil
            }

            return try JSONDecoder().decode([SingleStockDTO].self, from: data)
        } catch {
            print("❌ Erreur lors de la récupération des jeux vendus : \(error.localizedDescription)")
            return nil
        }
    }

    func withdrawGames(listOfGamesToWithdraw: WithdrawGamesDTO) async -> Bool {
        let urlString = "\(baseUrl)/withdraw"
        guard let url = URL(string: urlString) else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(listOfGamesToWithdraw)
            request.httpBody = jsonData

            let (_, response) = try await URLSession.shared.upload(for: request, from: jsonData)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur HTTP: \(response)")
                return false
            }

            return true
        } catch {
            print("❌ Erreur lors du retrait des jeux : \(error.localizedDescription)")
            return false
        }
    }
}
