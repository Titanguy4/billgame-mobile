import SwiftUI

struct AchatView: View {
    @StateObject private var viewModel = AchatViewModel()
    @State private var newGameEtiquette = ""
    @State private var showingAlert = false
    @State private var selectedPaymentMethod: String? = nil
    @State private var alertMessage: String = ""
    @State private var isShowingPurchaseAlert = false

    var body: some View {
        VStack {
            Text("Achat de jeux")
                .font(.largeTitle)
                .fontWeight(.bold)

            GameListView(games: viewModel.games, onRemoveGame: { game in
                viewModel.removeFromCart(game: game)
            })

            Button(action: {
                showingAlert = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.black)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }
            .padding(.top, 5)
            .alert("Ajouter un jeu", isPresented: $showingAlert) {
                TextField("Etiquette du jeu", text: $newGameEtiquette)
                Button("Ajouter") {
                    viewModel.addGame(etiquette: newGameEtiquette)
                    newGameEtiquette = ""
                }
                Button("Annuler", role: .cancel) {}
            }

            Divider()

            Text("Mode de paiement :")
                .font(.headline)
                .padding(.top, 10)

            HStack {
                Button(action: {
                    selectedPaymentMethod = "Credit Card"
                }) {
                    Text("Carte")
                        .font(.body)
                        .padding(8)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(selectedPaymentMethod == "Credit Card" ? Color.black : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    selectedPaymentMethod = "Cash"
                }) {
                    Text("Espèces")
                        .font(.body)
                        .padding(8)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(selectedPaymentMethod == "Cash" ? Color.black : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)

            Button(action: {
                finalizePurchase()
            }) {
                Label("Acheter", systemImage: "cart.fill")
                    .font(.body)
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(selectedPaymentMethod != nil ? Color.black : Color.gray)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top, 5)
            .disabled(selectedPaymentMethod == nil)
        }
        .padding()
        .onReceive(viewModel.$purchaseState) { state in
            switch state {
            case .success(let transactionId):
                alertMessage = "✅ Achat réussi, le total est de : \(transactionId)"
                isShowingPurchaseAlert = true
            case .failure(let error):
                alertMessage = "❌ Erreur lors de l'achat: \(error.localizedDescription)"
                isShowingPurchaseAlert = true
            case .idle:
                break
            }
        }
        .alert(isPresented: $isShowingPurchaseAlert) {
            Alert(title: Text("Statut de l'achat"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func finalizePurchase() {
        if let method = selectedPaymentMethod {
            Task {
                await viewModel.processPurchase(editInvoice: false, buyerUuid: nil, paymentMethod: method)
            }
        }
    }
}
