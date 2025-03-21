import SwiftUI

struct StockView: View {
    @State private var email: String = "diane.dubois@example.com"
    @State private var isEmailValid: Bool = false
    @State private var navigateToStock = false

    var body: some View {
        NavigationView {
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

                TextField("Email du vendeur", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: email) { newValue in
                        isEmailValid = isValidEmail(newValue)
                    }

                NavigationLink(destination: SellerStockView(email: email), isActive: $navigateToStock) {
                    EmptyView()
                }

                Button(action: {
                    if isEmailValid {
                        navigateToStock = true
                    }
                }) {
                    Text("Valider")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isEmailValid ? Color.black : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!isEmailValid)
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }

    // Vérification de l'email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
