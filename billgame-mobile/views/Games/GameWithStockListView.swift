import SwiftUI

struct GameWithStockListView: View {
    @ObservedObject private var gameViewModel: GameViewModel = GameViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(gameViewModel.allGames) { game in
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
    }
}
