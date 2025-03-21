import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    Text("Statistiques")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.top, 40)
                    
                    Text("Ces statistiques sont valables pour la session en cours")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Divider()
                    
                    if viewModel.isLoading {
                        // 📌 Loader centré sans affecter le reste de la vue
                        HStack {
                            Spacer()
                            VStack {
                                ProgressView()
                                    .scaleEffect(1.5) // Légèrement plus grand
                                    .padding(.bottom, 8)
                                
                                Text("Chargement...")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .frame(maxHeight: .infinity) // Pour bien centrer le loader verticalement
                    }
                    else if let stats = viewModel.statistics {
                        Text("Trésorerie")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            StatCard(title: "Trésorerie totale", value: "\(String(format: "%.2f", stats.tresorerieTotal)) €")
                            StatCard(title: "Somme due aux vendeurs", value: "\(String(format: "%.2f", stats.dueToVendor)) €")
                            StatCard(title: "Frais de dépôt encaissés", value: "\(String(format: "%.2f", stats.depositFeeCollected)) €")
                            StatCard(title: "Commissions prélevées", value: "\(String(format: "%.2f", stats.commissionFeeCollected)) €")
                            StatCard(title: "Montant retiré par les vendeurs", value: "\(String(format: "%.2f", stats.amountWithdrawn)) €")
                        }
                    }
                    else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding()
                .task {
                    await viewModel.fetchStatistics()
                }
            }
        }
    }
}
