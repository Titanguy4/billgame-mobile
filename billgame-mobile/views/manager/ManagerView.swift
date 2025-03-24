import SwiftUI

struct ManagerView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var navigateToHome = false // ✅ Gère la navigation

    var body: some View {
        NavigationStack {
            ZStack {
                TabView {
                    AchatView().tabItem { Image(systemName: "cart"); Text("Achat") }
                    DepotView().tabItem { Image(systemName: "square.and.arrow.down"); Text("Depot") }
                    StockView().tabItem { Image(systemName: "archivebox"); Text("Stock") }
                    StatsView().tabItem { Image(systemName: "chart.bar"); Text("Stats") }
                }
                .tint(.black)

                Image("manager")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.4)
                    .offset(y: 100)
                    .opacity(0.15)
                    .ignoresSafeArea()
            }
            .navigationTitle("Gestion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        loginViewModel.logout()
                        navigateToHome = true
                    }) {
                        Text("Se déconnecter")
                            .foregroundColor(.black)
                    }
                }
            }
            .onReceive(loginViewModel.objectWillChange) {
                if !loginViewModel.isAuthenticated {
                    navigateToHome = true
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
    }
}
