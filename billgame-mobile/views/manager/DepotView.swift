import SwiftUI

struct DepotView: View {
    @StateObject private var viewModel = DepotViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Accéder au dépôt")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 40)

                Text("Entrez l'email du vendeur pour déposer un ou plusieurs jeux")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                TextField("Email du vendeur", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: viewModel.email) { _ in
                        viewModel.validateEmail()
                    }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }

                NavigationLink(
                    destination: DepotFormView(email: viewModel.email),
                    isActive: $viewModel.isEmailVerified
                ) {
                    EmptyView()
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
        }
    }
}
