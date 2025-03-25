import Foundation

class UserService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr/user"
    private let httpService = HttpService()
    
    init() {}
    
    func getMerchantUUIDByEmail(email: String, completion: @escaping (Result<String, ErrorApi>) -> Void) {
        let urlString = "\(baseUrl)/seller/\(email)/uuid"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        httpService.get(url: url, success: { data, _ in
            if var uuid = String(data: data, encoding: .utf8), !uuid.isEmpty {
                uuid = uuid.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                completion(.success(uuid))
            } else {
                completion(.failure(.decodingError))
            }
        }, failure: { error in
            completion(.failure(.unknownError(error)))
        })
    }
    
    func createSeller(sellerDTO: SellerDTO, completion: @escaping (Result<Void, ErrorApi>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/seller") else {
            completion(.failure(.invalidURL))
            return
        }
        
        do {
            let body = try JSONEncoder().encode(sellerDTO)
            httpService.post(url: url, body: body, success: { _, _ in
                completion(.success(()))
            }, failure: { error in
                completion(.failure(.unknownError(error)))
            })
        } catch {
            completion(.failure(.decodingError))
        }
    }
    
    public func getUserList() async -> [User] {
            guard let url = URL(string: baseUrl) else {
                print("Erreur : problème en créant l'url pour getAllUsers")
                return []
            }
            
            do {
                let response: Data = try await withCheckedThrowingContinuation { continuation in
                    httpService.get(
                        url: url,
                        success: { body, _ in continuation.resume(returning: body) },
                        failure: { error in continuation.resume(throwing: error) }
                    )
                }
                
                let result = try JSONDecoder().decode([UserDTO].self, from: response)
                let users = result.map({User(from: $0)})
                return users
            } catch {
                print("Error while decoding list of users or fetching data: \(error)")
                return []
            }
        }
        
        public func modifyUser (_ user: User) async {
            guard let url = URL(string: "\(baseUrl)/\(user.id)") else {
                print("Erreur : problème en créant l'url pour getAllUsers")
                return
            }
            let userDTO : UserDTO = user.toDTO()
            let encoder = JSONEncoder()
            do {
                let jsonData = try encoder.encode(userDTO)
                httpService.patch(url: url, body: jsonData, success: {_,_ in }, failure: {_ in})
            } catch {
                print("Error while encoding data")
            }
        }
        
        public func deleteUser (_ user: User) async {
            guard let url = URL(string: "\(baseUrl)/\(user.id)") else {
                print("Erreur : problème en créant l'url pour getAllUsers")
                return
            }
            httpService.delete(url: url, success: {_,_ in print("Deletion went all good")}, failure: {error in print(error)})
        }
}
