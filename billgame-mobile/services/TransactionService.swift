import Foundation

enum TransactionError: Error {
    case invalidURL
    case missingToken
    case httpError(statusCode: Int)
    case decodingError
    case unknownError(Error)
}

class TransactionService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr/transaction"
    private let authTokenStore = AuthTokenStore()
    
    init() {}
    
    func postPurchase(purchase: PurchaseDTO, publish: Bool) async throws -> Int {
        print(purchase)
        let urlString = "\(baseUrl)/purchase?register=\(publish)"
        guard let url = URL(string: urlString) else {
            throw TransactionError.unknownError(NSError(domain: "URL Error", code: 1, userInfo: nil))
        }
        
        guard let token = authTokenStore.token else {
            throw TransactionError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(purchase)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            print(response)
            print(data)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TransactionError.httpError(statusCode: 0)
            }
            
            guard httpResponse.statusCode == 200 else {
                throw TransactionError.httpError(statusCode: httpResponse.statusCode)
            }
            
            return try JSONDecoder().decode(Int.self, from: data)
        } catch let error as DecodingError {
            throw TransactionError.decodingError
        } catch {
            throw TransactionError.unknownError(error)
        }
    }


    func getCurrentSessionStatistics() async throws -> StatisticsDTO {
        let urlString = "\(baseUrl)/statistics/current-session"
        guard let url = URL(string: urlString) else {
            throw TransactionError.unknownError(NSError(domain: "URL Error", code: 1, userInfo: nil))
        }
        
        guard let token = authTokenStore.token else {
            throw TransactionError.missingToken
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw TransactionError.httpError(statusCode: 0)
            }
            
            guard httpResponse.statusCode == 200 else {
                throw TransactionError.httpError(statusCode: httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            return try decoder.decode(StatisticsDTO.self, from: data)
        } catch let error as DecodingError {
            throw TransactionError.decodingError
        } catch {
            throw TransactionError.unknownError(error)
        }
    }

}
