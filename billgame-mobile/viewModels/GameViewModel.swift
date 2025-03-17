import Foundation

class GameViewModel: ObservableObject {
    @Published var games: [GameWithStock] = []
    private var service: GameService

    init(service: GameService){
        self.service = service
        Task{
            await loadGames()
        }
    }

    func loadGames() async {
        guard let games = await service.getAvailableStock() else {
            self.games = []
            return
        }
        self.games = games
        print(games[0].name)
    }

    func switchEditMode(game: GameWithStock) {
        print("Edit mode activé pour le jeu: \(game.name)")
    }
}
