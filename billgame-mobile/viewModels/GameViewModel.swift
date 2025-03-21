import Foundation

@MainActor
class GameViewModel: ObservableObject {
    @Published var allGames: [GameWithStock] = []
    
    private var service: GameService = GameService()
    
    init(){
        Task{
            await loadAllGames()
        }
    }
    
    func loadAllGames() async {
        guard let games = await service.getAvailableStock() else {
            self.allGames = []
            return
        }
        self.allGames = games
    }
}
