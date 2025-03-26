import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    @State private var navigateToAdmin = false
    @State private var navigateToManager = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("connection")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.4)
                    .offset(y: 100)
                    .opacity(0.15)
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Connexion")
                            .font(.title)
                            .bold()

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email")
                                .font(.headline)
                            TextField("Tapez votre email...", text: $viewModel.email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Mot de passe")
                                .font(.headline)
                            SecureField("Tapez votre mot de passe...", text: $viewModel.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Mot de passe oublié ?")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }

                        Button(action: {
                            viewModel.login()
                        }) {
                            Text("Se connecter")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.black)
                                .cornerRadius(20)
                        }

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                    }
                    .padding(30)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 4)
                    .frame(maxWidth: 400)

                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .onReceive(viewModel.objectWillChange) {
                if viewModel.isAuthenticated {
                    if viewModel.isAdmin {
                        navigateToAdmin = true
                    } else if viewModel.isManager {
                        navigateToManager = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToAdmin) {
                AdminView()
            }
            .navigationDestination(isPresented: $navigateToManager) {
                ManagerView()
            }
        }
    }
}
