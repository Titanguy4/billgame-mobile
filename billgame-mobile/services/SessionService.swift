import Foundation

class SessionService {
    init() {}

    func fetchCurrentSession() async -> SessionDTO? {
        let url = URL(string: "https://billgameback.mathiaspuyfages.fr/session/active")!
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Erreur HTTP: \(response)")
                return nil
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
            let sessionDTO = try decoder.decode(SessionDTO.self, from: data)
                        
            return sessionDTO
        } catch {
            print("❌ Erreur lors de la récupération de la session : \(error.localizedDescription)")
            return nil
        }
    }
}
