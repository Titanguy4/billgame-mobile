import SwiftUI

struct HomeSessionView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    @State var minPrice: Int? = nil
    @State var maxPrice: Int? = nil
    @State var gameName = ""
    @State var editorName = ""

    // Instancier GameViewModel
    @StateObject var gameViewModel = GameViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Image("session-active")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.4)
                    .offset(y: 100)
                    .opacity(0.15)
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()

                        Spacer()

                        if viewModel.isAuthenticated {
                            NavigationLink(destination: ManagerView()) {
                                Text("Dashboard")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(Color.black)
                                    .cornerRadius(25)
                            }
                        } else {
                            NavigationLink(destination: LoginView()) {
                                Text("Se connecter")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(Color.black)
                                    .cornerRadius(25)
                            }
                        }
                    }
                    .frame(height: 75)

                    Spacer().frame(height: 50)

                    VStack(spacing: 75) {
                        VStack(spacing: 15) {
                            Text("Super ! Un festival est ouvert.")
                                .font(.headline)
                                .bold()
                                .multilineTextAlignment(.center)

                            Text("Viens vite voir les jeux de sociétés que les commerçants de ton festival te proposent !")
                                .multilineTextAlignment(.leading)
                        }
                    }

                    Spacer().frame(height: 50)

                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Text("Rechercher un jeu")
                                .font(.system(size: 15))
                                .bold()
                            TextField("Tapez le nom du jeu...", text: $gameName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()

                    Spacer().frame(height: 20)

                    // Passer gameViewModel à GameWithStockListView
                    GameWithStockListView(gameViewModel: gameViewModel, searchQuery: $gameName)
                        .onAppear {
                            // Charger les jeux dès que la vue apparaît
                            Task {
                                await gameViewModel.loadAllGames()
                            }
                        }
                }
                .padding(20)
            }
        }
    }
}
