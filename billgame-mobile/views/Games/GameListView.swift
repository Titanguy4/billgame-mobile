import SwiftUI

struct GameListView: View {
    let games: [Game]
    var onRemoveGame: (Game) -> Void  // Closure pour supprimer un jeu

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(games) { game in
                    GameItemView(game: game)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                        .contextMenu {
                            Button(role: .destructive) {
                                onRemoveGame(game)
                            } label: {
                                Label("Supprimer", systemImage: "trash")
                            }
                        }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
