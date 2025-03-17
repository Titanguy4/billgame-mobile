import SwiftUI

struct AchatView: View {
    var authService = AuthService()
    
    var body: some View {
        Text(authService.getName() ?? "")
    }
}
