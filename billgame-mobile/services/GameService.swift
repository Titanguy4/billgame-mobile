import Foundation

class GameService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr"
    private let authTokenStore  = AuthTokenStore()

    init() {}

    func findGameByEtiquette(etiquette: String) async -> SingleStockDTO? {
        let urlString = "\(baseUrl)/stock/\(etiquette)?active=true"
        guard let url = URL(string: urlString) else { return nil }
        
        guard let token = authTokenStore.token else {
            print("❌ Aucun token trouvé")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur HTTP: \(response)")
                return nil
            }

            let decoder = JSONDecoder()

            return try decoder.decode(SingleStockDTO.self, from: data)
        } catch {
            print("❌ Erreur lors de la récupération du jeu : \(error.localizedDescription)")
            return nil
        }
    }

    func getAvailableStock() async -> [GameWithStock]? {
        guard let url = URL(string: baseUrl + "/stock") else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur HTTP: \(response)")
                return nil
            }
            
            let stockDTOs = try JSONDecoder().decode([StockDTO].self, from: data)
            return stockDTOs.map { GameWithStock.fromDTO($0) }
        } catch {
            print("❌ Erreur lors de la récupération du stock : \(error.localizedDescription)")
            return nil
        }
    }
}
