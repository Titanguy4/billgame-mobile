import SwiftUI

struct WithdrawSheetView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: StockViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Retirer une somme due")
                .font(.title2)
                .bold()

            TextField("Montant", text: $viewModel.withdrawAmount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()

            Text("Mode de paiement")
                .font(.headline)

            HStack {
                Button(action: { viewModel.selectedPaymentMethod = "Cash" }) {
                    Text("Espèce")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedPaymentMethod == "Cash" ? Color.black : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: { viewModel.selectedPaymentMethod = "Credit Card" }) {
                    Text("Carte bancaire")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedPaymentMethod == "Credit Card" ? Color.black : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)

            Button(action: {
                viewModel.withdrawMoney()
                isPresented = false
            }) {
                Text("Retirer")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.selectedPaymentMethod != nil ? Color.black : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(viewModel.selectedPaymentMethod == nil)

            Spacer()
        }
        .padding()
    }
}
