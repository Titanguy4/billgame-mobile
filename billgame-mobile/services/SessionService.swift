import Foundation

/// `SessionService` est une classe responsable de la gestion des sessions actives.
/// Elle interagit avec l'API du backend pour effectuer des actions comme la récupération, la création, la modification et la suppression des sessions.
class SessionService {
    private let baseURL: String = "https://billgameback.mathiaspuyfages.fr/session"
    private let httpService: HttpService
    
    /// Initialiseur de la classe `SessionService`.
    /// - Parameter httpService: Le service HTTP à utiliser pour effectuer les requêtes (par défaut, une instance de `HttpService` est utilisée).
    init(httpService: HttpService = HttpService()) {
        self.httpService = httpService
    }

    /// Récupère la session active du serveur en utilisant `httpService`.
    /// - Returns: Un objet `SessionDTO` représentant la session active si elle existe, sinon `nil`.
    public func fetchCurrentSession() async -> SessionDTO? {
        guard let url = URL(string: "\(baseURL)/active") else {
            print("❌ Erreur : URL invalide")
            return nil
        }

        do {
            let response: Data = try await withCheckedThrowingContinuation { continuation in
                httpService.get(
                    url: url,
                    success: { body, _ in continuation.resume(returning: body) },
                    failure: { error in continuation.resume(throwing: error) }
                )
            }
            return try JSONDecoder().decode(SessionDTO.self, from: response)
        } catch {
            print("❌ Erreur lors de la récupération de la session : \(error.localizedDescription)")
            return nil
        }
    }

    /// Récupère toutes les sessions du serveur.
    /// - Returns: Un tableau d'objets `Session` représentant toutes les sessions disponibles, ou un tableau vide en cas d'erreur.
    public func getAllSession() async -> [Session] {
        guard let url = URL(string: baseURL) else {
            print("❌ Erreur de création de l'URL")
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
            let result = try JSONDecoder().decode([SessionDTO].self, from: response)
            return result.map { Session(from: $0) }
        } catch {
            print("❌ Erreur lors de la récupération des sessions : \(error)")
            return []
        }
    }

    /// Crée une nouvelle session sur le serveur.
    /// - Parameter session: La session à créer.
    public func createSession(_ session: Session) async {
        guard let url = URL(string: baseURL) else { return }
        let dto = session.toDTO()
        let encoder = JSONEncoder()

        do {
            let jsonData = try encoder.encode(dto)
            httpService.post(
                url: url,
                body: jsonData,
                success: { _, _ in print("✅ Session créée avec succès") },
                failure: { error in print("❌ Erreur lors de la création de la session : \(error)") }
            )
        } catch {
            print("❌ Erreur d'encodage JSON : \(error)")
        }
    }

    /// Modifie une session existante sur le serveur.
    /// - Parameter session: La session à modifier.
    public func modifySession(session: Session) async {
        guard let url = URL(string: "\(baseURL)/\(session.id)") else { return }
        let dto = session.toDTO()
        let encoder = JSONEncoder()

        do {
            let jsonData = try encoder.encode(dto)
            httpService.patch(
                url: url,
                body: jsonData,
                success: { _, _ in print("✅ Session modifiée avec succès") },
                failure: { error in print("❌ Erreur lors de la modification de la session : \(error)") }
            )
        } catch {
            print("❌ Erreur d'encodage JSON : \(error)")
        }
    }

    /// Supprime une session du serveur.
    /// - Parameter session: La session à supprimer.
    public func deleteSession(_ session: Session) async {
        guard let url = URL(string: "\(baseURL)/\(session.id)") else {
            print("❌ Erreur : URL invalide pour la suppression")
            return
        }
        
        httpService.delete(
            url: url,
            success: { _, _ in print("✅ Session supprimée avec succès") },
            failure: { error in print("❌ Erreur lors de la suppression de la session : \(error)") }
        )
    }
}
