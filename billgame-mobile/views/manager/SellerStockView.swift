import SwiftUI

struct SellerStockView: View {
    @ObservedObject var viewModel: StockViewModel
    @State private var showWithdrawSheet = false
    @State private var showWithdrawGamesSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Stock du vendeur")
                    .font(.largeTitle)
                    .bold()

                Text(viewModel.email)
                    .font(.headline)
                    .foregroundColor(.gray)

                if let messageError = viewModel.messageError {
                    Text(messageError)
                        .foregroundColor(.red)
                        .font(.body)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                VStack(spacing: 10){
                    HStack(spacing: 10) {
                        StatCard(title: "Jeux en vente", value: "\(viewModel.availableGames.count)")
                        StatCard(title: "Jeux vendus", value: "\(viewModel.soldGames.count)")
                    }
                    HStack(spacing: 10) {
                        StatCard(title: "Somme due", value: viewModel.moneyDue != nil ? "\(viewModel.moneyDue!)€" : "N/A")
                    }
                }
                

                HStack(spacing: 10) {
                    Button(action: { showWithdrawGamesSheet = true }) {
                        Image(systemName: "shippingbox.and.arrow.backward")
                            .frame(width: 40, height: 40)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Button(action: { showWithdrawSheet = true }) {
                        Image(systemName: "creditcard")
                            .frame(width: 40, height: 40)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                SectionView(title: "Jeux en vente", jeux: viewModel.availableGames)
                SectionView(title: "Jeux vendus", jeux: viewModel.soldGames)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("Stock", displayMode: .inline)
        .sheet(isPresented: $showWithdrawSheet) {
            WithdrawSheetView(isPresented: $showWithdrawSheet, viewModel: viewModel)
        }
        .sheet(isPresented: $showWithdrawGamesSheet) {
            WithdrawGamesSheetView(isPresented: $showWithdrawGamesSheet, viewModel: viewModel)
        }
    }
}
