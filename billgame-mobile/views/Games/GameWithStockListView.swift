import SwiftUI

struct GameWithStockListView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @Binding var searchQuery: String

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(filteredGames) { game in
                    GameWithStockItemView(game: game)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                }
            }
            .padding(.horizontal, 10)
        }
        .onAppear {
            if gameViewModel.allGames.isEmpty {
                Task {
                    await gameViewModel.loadAllGames()
                }
            }
        }
    }

    private var filteredGames: [GameWithStock] {
        if searchQuery.isEmpty {
            return gameViewModel.allGames
        } else {
            return gameViewModel.allGames.filter { game in
                game.name.lowercased().hasPrefix(searchQuery.lowercased())
            }
        }
    }
}
