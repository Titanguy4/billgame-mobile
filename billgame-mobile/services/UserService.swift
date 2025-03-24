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

    func getAllUsers(completion: @escaping (Result<[UserDTO], ErrorApi>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(.failure(.invalidURL))
            return
        }

        httpService.get(url: url, success: { data, _ in
            do {
                let users = try JSONDecoder().decode([UserDTO].self, from: data)
                completion(.success(users))
            } catch {
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
    
    func editUser(userDTO: UserDTO, completion: @escaping (Result<Void, ErrorApi>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/\(userDTO.uuid)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        do {
            let body = try JSONEncoder().encode(userDTO)
            httpService.put(url: url, body: body, success: { _, _ in
                completion(.success(()))
            }, failure: { error in
                completion(.failure(.unknownError(error)))
            })
        } catch {
            completion(.failure(.decodingError))
        }
    }
    
    func deleteUser(uuid: String, completion: @escaping (Result<Void, ErrorApi>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/\(uuid)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        httpService.delete(url: url, success: { _, _ in
            completion(.success(()))
        }, failure: { error in
            completion(.failure(.unknownError(error)))
        })
    }
}
