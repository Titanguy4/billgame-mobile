import SwiftUI

struct StockView: View {
    @StateObject private var viewModel = StockViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Accéder au stock")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                Text("Entrez l'email du vendeur pour voir son stock")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                TextField("Email du vendeur", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: viewModel.email) {
                        viewModel.validateEmail()
                    }
                
                if let messageError = viewModel.messageError {
                    Text(messageError)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    viewModel.validateEmail()
                }) {
                    Text("Valider")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isEmailValid ? Color.black : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isEmailValid)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.isEmailVerified) {
                SellerStockView(viewModel: viewModel)
            }
        }
    }
}
