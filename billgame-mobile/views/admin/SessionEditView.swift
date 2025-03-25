import SwiftUI

struct SessionEditView: View {
    @State private var editedSession: Session
    var onSave: (Session) -> Void
    @Environment(\.dismiss) private var dismiss
    
    init(session: Session, onSave: @escaping (Session) -> Void) {
        self._editedSession = State(initialValue: Session(
            id: session.id,
            ds: session.debutSession,
            fs: session.finSession,
            dd: session.debutDepot,
            fd: session.finDepot,
            dv: session.debutVente,
            fv: session.finVente,
            com: session.commission,
            fraisDep: session.fraisDepot,
            adresse: session.adresse,
            isDepositFeePercentage: session.isDepositFeePercentage,
            areCommissionPercentage: session.areCommissionPercentage
        ))
        self.onSave = onSave
    }
    
    init (onSave: @escaping (Session) -> Void) {
        self._editedSession = State(initialValue: Session(
            id: "newSession",
            ds: Date(),
            fs: Date(),
            dd: Date(),
            fd: Date(),
            dv: Date(),
            fv: Date(),
            com: 0,
            fraisDep: 0,
            adresse: "",
            isDepositFeePercentage: false,
            areCommissionPercentage: false
        ))
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations de la session")) {
                    DatePicker("Début de la session", selection: $editedSession.debutSession, displayedComponents: .date)
                    DatePicker("Fin de la session", selection: $editedSession.finSession, displayedComponents: .date)
                    DatePicker("Fin du dépôt", selection: $editedSession.finDepot, displayedComponents: .date)
                    DatePicker("Début de la vente", selection: $editedSession.debutVente, displayedComponents: .date)
                    
                    TextField("Commission", value: $editedSession.commission, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Frais de dépôt", value: $editedSession.fraisDepot, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Adresse", text: $editedSession.adresse)
                    
                    Toggle("Commission en pourcentage", isOn: $editedSession.areCommissionPercentage)
                    Toggle("Frais de dépôt en pourcentage", isOn: $editedSession.isDepositFeePercentage)
                }
            }
            .navigationTitle("Modifier la session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        editedSession.debutDepot = editedSession.debutSession
                        editedSession.finVente = editedSession.finSession
                        onSave(editedSession)
                        dismiss()
                    }
                }
            }
        }
    }
}
