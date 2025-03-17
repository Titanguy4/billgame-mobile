import SwiftUI

struct GameListView: View {
    @StateObject var viewModel = GameViewModel(service: GameService())
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.games) { game in
                    GameItemView(game: game, withStock: true)
                        .onTapGesture {
                            viewModel.switchEditMode(game: game)
                        }
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
        .background(Color.clear)
    }
}

#Preview {
    GameListView()
}
