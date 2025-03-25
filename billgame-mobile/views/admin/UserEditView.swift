import SwiftUI

struct UserEditView: View {
    @State private var editedUser: User
    var onSave: (User) -> Void
    @Environment(\.dismiss) private var dismiss
    
    init (user : User, onSave: @escaping (User) -> Void) {
        self._editedUser = State(initialValue: User(id: user.id, name: user.name, email: user.email, phone: user.phone, role: user.role))
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations personnelles")) {
                    TextField("Nom", text: $editedUser.name)
                    TextField("Email", text: $editedUser.email)
                        .keyboardType(.emailAddress)
                    TextField("Téléphone", text: $editedUser.phone)
                        .keyboardType(.phonePad)
                    TextField("Rôle", text: $editedUser.role)
                }
            }
            .navigationTitle("Modifier \(editedUser.name)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        print(editedUser)
                        onSave(editedUser)
                        dismiss()
                    }
                }
            }
        }
    }
}
