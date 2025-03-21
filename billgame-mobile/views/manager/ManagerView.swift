import SwiftUI

struct ManagerView: View {
    var body: some View {
        ZStack {
            TabView {
                AchatView().tabItem{ Image(systemName: "cart"); Text("Achat")}
                DepotView().tabItem{ Image(systemName: "square.and.arrow.down"); Text("Depot")}
                StockView().tabItem{ Image(systemName: "archivebox"); Text("Stock")}
                StatsView().tabItem{ Image(systemName: "chart.bar"); Text("Stats")}
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
    }
}

#Preview {
    ManagerView()
}
