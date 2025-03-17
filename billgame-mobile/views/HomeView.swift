import SwiftUI

struct HomeView: View {
    @StateObject var sessionVM = SessionViewModel()
    
    var body: some View {
        if sessionVM.currentSession != nil {
            HomeSessionView()
        }else{
            HomeNonSessionView()
        }
    }
}

#Preview {
    HomeView()
}
