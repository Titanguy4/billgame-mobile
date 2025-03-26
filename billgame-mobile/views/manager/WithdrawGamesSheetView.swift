import SwiftUI

struct WithdrawGamesSheetView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: StockViewModel

    var body: some View {
        VStack {
            Text("Retirer des jeux du vendeur")
                .font(.title2)
                .bold()
                .padding()
            
            if let errorMessage = viewModel.messageError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            ScrollView {
                VStack(alignment: .leading) {
                    Text("Liste des jeux non vendus")
                        .font(.headline)
                        .padding(.bottom, 5)

                    ForEach(viewModel.availableGames, id: \.etiquette) { game in
                        HStack {
                            Toggle(isOn: bindingForGame(game)) {
                                Text("\(game.etiquette) \(game.name)")
                                    .font(.body)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()
            }

            Button(action: {
                viewModel.withdrawSelectedGames()
            }) {
                Text("Retirer")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.selectedGamesToWithdraw.isEmpty ? Color.gray : Color.black)
                    .cornerRadius(10)
            }
            .disabled(viewModel.selectedGamesToWithdraw.isEmpty)
            .padding()

            Spacer()
        }
        .padding()
        .onChange(of: viewModel.withdrawSuccess) { oldValue, newValue in
            if newValue {
                isPresented = false
            }
        }
    }
    
    private func bindingForGame(_ game: Game) -> Binding<Bool> {
        Binding(
            get: { viewModel.selectedGamesToWithdraw.contains(game.etiquette) },
            set: { isSelected in
                if isSelected {
                    viewModel.addGameToWithdraw(game.etiquette)
                } else {
                    viewModel.removeGameFromWithdraw(game.etiquette)
                }
            }
        )
    }
}
