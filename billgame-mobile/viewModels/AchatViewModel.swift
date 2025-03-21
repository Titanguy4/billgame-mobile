import SwiftUI

enum PurchaseState {
    case idle
    case success(transactionId: Int)
    case failure(error: Error)
}


@MainActor
class AchatViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var purchaseState: PurchaseState = .idle
    
    private let gameService: GameService = GameService()
    private let transactionService: TransactionService = TransactionService()
    
    func addGame(etiquette: String) {
        guard !etiquette.isEmpty else { return }
        
        Task {
            if let gameDTO = await gameService.findGameByEtiquette(etiquette: etiquette) {
                let game = Game.fromDTO(gameDTO)
                
                await MainActor.run {
                    self.games.append(game)
                }
            } else {
                print("❌ Aucun jeu trouvé pour cette étiquette.")
            }
        }
    }
    
    func removeFromCart(game: Game) {
        games.removeAll { $0.etiquette == game.etiquette }
    }
    
    func processPurchase(editInvoice: Bool, buyerUuid: String?, paymentMethod: String) async {
        let labels = games.map { $0.etiquette }
        let purchaseDTO = PurchaseDTO(editInvoice: editInvoice, buyerUuuid: buyerUuid, stockLabel: labels, paymentMethode: paymentMethod)
        
        do {
            let result = try await transactionService.postPurchase(purchase: purchaseDTO, publish: true)
            await MainActor.run {
                self.purchaseState = .success(transactionId: result)
                self.games = []
            }
        } catch {
            await MainActor.run {
                self.purchaseState = .failure(error: error)
            }
        }
    }
}
