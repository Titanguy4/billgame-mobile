import SwiftUI

struct GameItemView: View {
    let game: Game

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(game.name)
                .font(.system(size: 16, weight: .bold))
            Text(game.editor)
                .font(.system(size: 12))
            Text("\(game.price, specifier: "%.2f")€")
                .font(.system(size: 14))
        }
        .padding(8)
    }
}
