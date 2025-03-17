import SwiftUI

struct GameItemView: View {
    let game: GameWithStock
    let withStock: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(game.name)
                .font(.system(size: 16, weight: .bold))
            Text(game.editor)
                .font(.system(size: 12))
            Text("\(game.price, specifier: "%.2f")€")
                .font(.system(size: 14))
            if withStock {
                Text("Stock: \(game.stock)")
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
            }
        }
        .padding(8)
    }
}
