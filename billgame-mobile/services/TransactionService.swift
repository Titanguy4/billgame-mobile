import Foundation

class TransactionService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr/transaction"
    private let httpService: HttpService

    init(httpService: HttpService = HttpService()) {
        self.httpService = httpService
    }
    
    func withdrawAmount(dto: WithdrawAmountDTO, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/seller-money-withdraw") else {
            completion(.failure(ErrorApi.invalidURL))
            return
        }

        do {
            let jsonData = try JSONEncoder().encode(dto)
            httpService.post(url: url, body: jsonData, success: { _, _ in
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            }, failure: { error in
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            })
            
        } catch {
            completion(.failure(error))
        }
    }

    func postPurchase(purchase: PurchaseDTO, publish: Bool) async throws -> Int {
        let urlString = "\(baseUrl)/purchase?register=\(publish)"
        guard let url = URL(string: urlString) else {
            throw ErrorApi.invalidURL
        }

        let jsonData = try JSONEncoder().encode(purchase)

        return try await withCheckedThrowingContinuation { continuation in
            httpService.post(url: url, body: jsonData) { data, _ in
                do {
                    let purchaseId = try JSONDecoder().decode(Int.self, from: data)
                    continuation.resume(returning: purchaseId)
                } catch {
                    continuation.resume(throwing: ErrorApi.decodingError)
                }
            } failure: { error in
                continuation.resume(throwing: ErrorApi.unknownError(error))
            }
        }
    }

    func getCurrentSessionStatistics() async throws -> StatisticsDTO {
        let urlString = "\(baseUrl)/statistics/current-session"
        guard let url = URL(string: urlString) else {
            throw ErrorApi.invalidURL
        }

        return try await withCheckedThrowingContinuation { continuation in
            httpService.get(url: url) { data, _ in
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let statistics = try decoder.decode(StatisticsDTO.self, from: data)
                    continuation.resume(returning: statistics)
                } catch {
                    continuation.resume(throwing: ErrorApi.decodingError)
                }
            } failure: { error in
                continuation.resume(throwing: ErrorApi.unknownError(error))
            }
        }
    }
    
    func getMoneyDueToSeller(sellerUUID: String, completion: @escaping (Result<Double, ErrorApi>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/seller-money-withdraw/\(sellerUUID)") else {
            completion(.failure(.invalidURL))
            return
        }

        httpService.get(url: url, success: { data, _ in
            do {
                let amountDue = try JSONDecoder().decode(Double.self, from: data)
                completion(.success(amountDue))
            } catch {
                completion(.failure(.decodingError))
            }
        }, failure: { error in
            completion(.failure(.unknownError(error)))
        })
    }
}
