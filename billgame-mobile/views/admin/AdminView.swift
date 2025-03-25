import SwiftUI

struct AdminView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            ZStack {
                TabView {
                    AdminUserView().tabItem { Image(systemName: "person.3"); Text("Users") }
                    AdminSessionView().tabItem { Image(systemName: "clock"); Text("Sessions") }
                }
                .tint(.black)

                Image("admin")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.4)
                    .offset(y: 100)
                    .opacity(0.15)
                    .ignoresSafeArea()
            }
            .navigationTitle("Administration")
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
