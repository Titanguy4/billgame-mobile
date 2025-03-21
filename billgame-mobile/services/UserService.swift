import Foundation

enum UserError: Error {
    case invalidURL
    case missingToken
    case httpError(statusCode: Int)
    case decodingError
    case unknownError(Error)
}

class UserService {
    private let baseUrl = "https://billgameback.mathiaspuyfages.fr/user"
    private let authTokenStore = AuthTokenStore()
    
    init() {}
    
    func getAllUsers() async throws -> [UserDTO] {
        let urlString = baseUrl
        guard let url = URL(string: urlString) else {
            throw UserError.invalidURL
        }
        
        guard let token = authTokenStore.token else {
            throw UserError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw UserError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            return try JSONDecoder().decode([UserDTO].self, from: data)
        } catch {
            throw UserError.unknownError(error)
        }
    }
    
    func getMerchantUUIDByEmail(email: String) async throws -> String {
        let urlString = "\(baseUrl)/seller/\(email)/uuid"
        guard let url = URL(string: urlString) else {
            throw UserError.invalidURL
        }
        
        guard let token = authTokenStore.token else {
            throw UserError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw UserError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            return try JSONDecoder().decode(String.self, from: data)
        } catch {
            throw UserError.unknownError(error)
        }
    }
    
    func createSeller(sellerDTO: UserDTO) async throws {
        let urlString = "\(baseUrl)/seller"
        guard let url = URL(string: urlString) else {
            throw UserError.invalidURL
        }
        
        guard let token = authTokenStore.token else {
            throw UserError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(sellerDTO)
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw UserError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
        } catch {
            throw UserError.unknownError(error)
        }
    }
    
    func editUser(userDTO: UserDTO) async throws {
        let urlString = "\(baseUrl)/\(userDTO.uuid)"
        guard let url = URL(string: urlString) else {
            throw UserError.invalidURL
        }
        
        guard let token = authTokenStore.token else {
            throw UserError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(userDTO)
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw UserError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
        } catch {
            throw UserError.unknownError(error)
        }
    }
    
    func deleteUser(uuid: String) async throws {
        let urlString = "\(baseUrl)/\(uuid)"
        guard let url = URL(string: urlString) else {
            throw UserError.invalidURL
        }
        
        guard let token = authTokenStore.token else {
            throw UserError.missingToken
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw UserError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
        } catch {
            throw UserError.unknownError(error)
        }
    }
}

