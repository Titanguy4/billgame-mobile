import SwiftUI

struct RegisterSellerView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DepotViewModel

    var body: some View {
        VStack(spacing: 15) {
            Text("Créer un vendeur")
                .font(.title)
                .bold()
                .padding()

            VStack(alignment: .leading) {
                Text("Nom")
                    .font(.headline)
                TextField("Entrez le nom", text: $viewModel.sellerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Email")
                    .font(.headline)
                TextField("Entrez l'email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Numéro de téléphone")
                    .font(.headline)
                TextField("Entrez le numéro de téléphone", text: $viewModel.sellerPhone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Mot de passe")
                    .font(.headline)
                SecureField("Entrez le mot de passe", text: $viewModel.sellerPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Réduction (%)")
                    .font(.headline)
                TextField("Entrez une réduction", text: $viewModel.sellerDiscount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
            }
            .padding(.horizontal)

            Button(action: {
                viewModel.createSeller()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Créer vendeur")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 20)
    }
}
