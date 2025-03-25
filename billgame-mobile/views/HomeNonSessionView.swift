import SwiftUI

struct HomeNonSessionView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("session-non-active")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.4)
                    .offset(y: 100)
                    .opacity(0.15)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                        
                        Spacer()
                        
                        if viewModel.isAuthenticated {
                            if viewModel.isAdmin {
                                NavigationLink(destination: AdminView()) {
                                    Text("Admin Dashboard")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(Color.black)
                                        .cornerRadius(25)
                                }
                            } else if viewModel.isMerchant {
                                NavigationLink(destination: ManagerView()) {
                                    Text("Dashboard Vendeur")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(Color.black)
                                        .cornerRadius(25)
                                }
                            } else {
                                NavigationLink(destination: LoginView()) {
                                    Text("Se connecter")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(Color.black)
                                        .cornerRadius(25)
                                }
                            }
                        } else {
                            NavigationLink(destination: LoginView()) {
                                Text("Se connecter")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(Color.black)
                                    .cornerRadius(25)
                            }
                        }
                    }
                    .frame(height: 75)
                    
                    Spacer().frame(height: 50)
                    
                    ScrollView {
                        VStack(spacing: 75) {
                            VStack(spacing: 15) {
                                Text("Oh oh, aucun festival n’a ouvert de session...")
                                    .font(.headline)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                
                                Text("Revenez plus tard pour voir les nouveaux jeux de société proposés par les commerçants. Le prochain festival est dans :")
                                    .multilineTextAlignment(.leading)
                            }
                            
                            HStack(spacing: 45) {
                                VStack {
                                    Text("0")
                                        .font(.title)
                                        .bold()
                                    Text("jours")
                                        .font(.headline)
                                }
                                VStack {
                                    Text("0")
                                        .font(.title)
                                        .bold()
                                    Text("heures")
                                        .font(.headline)
                                }
                                VStack {
                                    Text("0")
                                        .font(.title)
                                        .bold()
                                    Text("minutes")
                                        .font(.headline)
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
    }
}
