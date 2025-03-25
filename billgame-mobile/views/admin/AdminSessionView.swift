import SwiftUI

struct AdminSessionView: View {
    @ObservedObject var adminSessionViewModel = AdminSessionViewModel()
    @State public var isCreatingSession : Bool = false

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter
    }
    
    var body: some View {
        VStack {
            Button(action: {
                isCreatingSession = true
            }) {
                Label("Créer une session", systemImage: "plus")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            List {
                ForEach(adminSessionViewModel.sessions) { session in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "clock")
                            Text("Début de session: \(formattedDate(session.debutSession))H")
                        }
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                            Text("Fin de session: \(formattedDate(session.finSession))H")
                        }
                        HStack {
                            Image(systemName: "folder")
                            Text("Début des dépôts: \(formattedDate(session.debutDepot))H")
                        }
                        HStack {
                            Image(systemName: "folder.badge.plus")
                            Text("Fin des dépôts: \(formattedDate(session.finDepot))H")
                        }
                        HStack {
                            Image(systemName: "cart")
                            Text("Début de la vente: \(formattedDate(session.debutVente))H")
                        }
                        HStack {
                            Image(systemName: "cart.badge.plus")
                            Text("Fin de la vente: \(formattedDate(session.finVente))H")
                        }
                        HStack {
                            Image(systemName: "percent")
                            Text("Commissions: \(session.commission, specifier: "%.2f") \(session.areCommissionPercentage ? "%" : "€/jeu")")
                        }
                        HStack {
                            Image(systemName: "dollarsign.circle")
                            Text("Frais de dépôt: \(session.fraisDepot, specifier: "%.2f") \(session.isDepositFeePercentage ? "%" : "€/depôt")")
                        }
                        HStack {
                            Image(systemName: "location")
                            Text("Adresse: \(session.adresse)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .swipeActions {
                        Button {
                            adminSessionViewModel.editSession(session)
                        } label: {
                            Label("Modifier", systemImage: "pencil")
                        }
                        .tint(.blue)
                        
                        Button(role: .destructive) {
                            withAnimation {
                                adminSessionViewModel.deleteSession(session)
                            }
                        } label: {
                            Label("Supprimer", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .sheet(item: $adminSessionViewModel.selectedSession) { session in
            SessionEditView(session: session, onSave: { updatedSession in
                return adminSessionViewModel.updateSession(updatedSession)
            })
        }
        .sheet(isPresented: $isCreatingSession) {
            SessionEditView(onSave: { newSession in
                adminSessionViewModel.createSession(newSession)
                isCreatingSession = false
            })
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
