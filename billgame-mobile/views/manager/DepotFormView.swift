import SwiftUI

struct DepotFormView: View {

    let gameList = [
        "Dragon’s Quest",
        "Puzzle Masters",
        "Treasure Hunters",
        "Family Night",
        "Haunted Mansion",
        "Space Explorers",
        "Logical Thinkers",
        "Adventure Island",
        "Party Fun",
        "Murder Mystery"
    ]

    @ObservedObject var viewModel: DepotViewModel

    @State private var selectedGame = "Dragon’s Quest"
    @State private var prix = ""
    @State private var quantite = "1"
    @State private var showAlert = false
    @State private var showingSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Déposer un jeu")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(viewModel.gamesToDeposit.indices, id: \.self) { index in
                        let game = viewModel.gamesToDeposit[index]
                        VStack(alignment: .leading) {
                            Text(game.name)
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("Éditeur: \(game.editor)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Prix: \(String(format: "%.2f", game.price))€")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Text("Stock: \(game.stock)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5)
                        .contextMenu {
                            Button(role: .destructive) {
                                viewModel.removeGame(at: index) // Appel à la méthode de suppression
                            } label: {
                                Label("Supprimer", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            HStack {
                Spacer()
                Button(action: { showingSheet = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding(14)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                Spacer()
            }
            .padding(.vertical, 10)

            .sheet(isPresented: $showingSheet) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Ajouter un jeu")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Nom du jeu")
                            .font(.headline)
                            .foregroundColor(.black)
                        Picker("Sélectionner un jeu", selection: $selectedGame) {
                            ForEach(gameList, id: \.self) { game in
                                Text(game)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .tint(.black)
                        .onChange(of: selectedGame) { newGame in
                            viewModel.fetchEditor(for: newGame)
                        }

                        Text("Éditeur")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(viewModel.selectedEditor)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("Prix")
                            .font(.headline)
                            .foregroundColor(.black)
                        TextField("Prix (€)", text: $prix)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity, minHeight: 44)

                        Text("Quantité")
                            .font(.headline)
                            .foregroundColor(.black)
                        TextField("Quantité", text: $quantite)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .padding(.horizontal)

                    HStack(spacing: 10) {
                        Button(action: {
                            viewModel.addGame(nom: selectedGame, editeur: viewModel.selectedEditor, prix: prix, quantite: quantite)
                            selectedGame = gameList[0]
                            prix = ""
                            quantite = "1"
                            showingSheet = false
                        }) {
                            Text("Ajouter")
                                .bold()
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }

                        Button(action: { showingSheet = false }) {
                            Text("Annuler")
                                .bold()
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(Color.gray.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 5)
                .padding(20)
            }

            Divider()

            Button(action: {
                viewModel.submitDeposit()
                showAlert = true
            }) {
                Text("Soumettre le dépôt")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding()
            .alert(isPresented: $showAlert) {
                switch viewModel.depotState {
                case .success(let message):
                    return Alert(title: Text("Succès"), message: Text(message), dismissButton: .default(Text("OK")))
                case .failure(let message):
                    return Alert(title: Text("Erreur"), message: Text(message), dismissButton: .default(Text("OK")))
                case .idle:
                    return Alert(title: Text("Info"), message: Text("Aucune action effectuée."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}
