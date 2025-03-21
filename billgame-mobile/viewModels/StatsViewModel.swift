import Foundation

@MainActor
class StatsViewModel: ObservableObject {
    @Published var statistics: StatisticsDTO?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let transactionService: TransactionService

    init(transactionService: TransactionService = TransactionService()) {
        self.transactionService = transactionService
    }

    func fetchStatistics() async {
        isLoading = true
        errorMessage = nil
        do {
            statistics = try await transactionService.getCurrentSessionStatistics()
        } catch let error as TransactionError {
            switch error {
            case .invalidURL:
                errorMessage = "❌ URL invalide. Vérifiez l'adresse de l'API."
            case .missingToken:
                errorMessage = "❌ Aucun token trouvé. Veuillez vous reconnecter."
            case .httpError(let statusCode):
                errorMessage = "❌ Erreur HTTP \(statusCode)."
            case .decodingError:
                errorMessage = "❌ Erreur de décodage des données."
            case .unknownError(let underlyingError):
                errorMessage = "❌ Erreur inconnue : \(underlyingError.localizedDescription)"
            }
        } catch {
            errorMessage = "❌ Erreur inattendue : \(error.localizedDescription)"
        }
        isLoading = false
    }
}
