import SwiftUI

struct DepotView: View {
    @StateObject var depotViewModel: DepotViewModel = DepotViewModel()
    @State private var navigateToDepot = false
    @State private var showRegisterSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Accéder au dépôt")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                Text("Entrez l'email du vendeur pour voir déposer un ou plusieurs jeux")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                TextField("Email du vendeur", text: $depotViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                if let errorMessage = depotViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                
                NavigationLink(
                    destination: DepotFormView(viewModel: depotViewModel),
                    isActive: $navigateToDepot
                ) {
                    EmptyView()
                }
                .onChange(of: depotViewModel.isEmailVerified, initial: false) {
                    if depotViewModel.isEmailVerified {
                        navigateToDepot = true
                    }
                }
                
                Button(action: {
                        depotViewModel.checkMerchantEmail()
                }) {
                    Text("Valider")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(depotViewModel.isEmailValid ? Color.black : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!depotViewModel.isEmailValid || depotViewModel.isLoading)
                .padding(.horizontal)

                Button(action: {
                    showRegisterSheet = true
                }) {
                    Text("Créer un vendeur")
                        .font(.headline)
                        .foregroundColor(.black)
                        .underline()
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showRegisterSheet) {
                RegisterSellerView(viewModel: depotViewModel)
            }
        }
    }
}
