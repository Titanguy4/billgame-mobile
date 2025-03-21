import Foundation

enum StockError: Error {
    case invalidURL
    case missingToken
    case httpError(statusCode: Int)
    case decodingError
    case unknownError(Error)
}

class StockService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr/stock"
    private let authTokenStore = AuthTokenStore()
    
    init() {}
    
    func findGameByEtiquette(etiquette: String) async throws -> SingleStockDTO {
        let urlString = "\(baseUrl)/\(etiquette)?active=true"
        guard let url = URL(string: urlString) else {
            throw StockError.invalidURL
        }
        
        guard let token = authTokenStore.token else {
            throw StockError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw StockError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            return try JSONDecoder().decode(SingleStockDTO.self, from: data)
        } catch {
            throw StockError.unknownError(error)
        }
    }
    
    func postDeposit(deposit: DepositDTO, publish: Bool) async throws -> Int {
        let urlString = "\(baseUrl)/deposit?publish=\(publish)"
        guard let url = URL(string: urlString) else {
            throw StockError.invalidURL
        }
        
        guard let token = authTokenStore.token else {
            throw StockError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(deposit)
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw StockError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            return try JSONDecoder().decode(Int.self, from: data)
        } catch {
            throw StockError.unknownError(error)
        }
    }
    
    func getAvailableStock() async throws -> [StockDTO] {
        let urlString = "\(baseUrl)"
        guard let url = URL(string: urlString) else {
            throw StockError.invalidURL
        }
        
        guard let token = authTokenStore.token else {
            throw StockError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw StockError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            return try JSONDecoder().decode([StockDTO].self, from: data)
        } catch {
            throw StockError.unknownError(error)
        }
    }
    
    func withdrawGames(listOfGamesToWithdraw: WithdrawGamesDTO) async throws {
        let urlString = "\(baseUrl)/withdraw"
        guard let url = URL(string: urlString) else {
            throw StockError.invalidURL
        }
        
        guard let token = authTokenStore.token else {
            throw StockError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(listOfGamesToWithdraw)
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw StockError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
        } catch {
            throw StockError.unknownError(error)
        }
    }
}
