import SwiftUI

@main
struct billgameMobileApp: App {
    @StateObject var loginViewModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(loginViewModel)
        }
    }
}
