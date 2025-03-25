import SwiftUI

struct AdminUserView : View {
    @ObservedObject var adminUserViewModel = AdminUserViewModel()
    
    var body : some View {
        HStack {
            List {
                ForEach(adminUserViewModel.users) { user in
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.black)
                            Text(user.phone)
                                .font(.subheadline)
                        }
                        
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.black)
                            Text(user.role)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 5)
                    .swipeActions {
                        Button(role: .destructive) {
                            adminUserViewModel.deleteUser(user)
                        } label: {
                            Label("Supprimer", systemImage: "trash")
                        }
                        Button {
                            adminUserViewModel.editUser(user)
                        } label: {
                            Label("Modifier", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .navigationTitle("Comptes des utilisateurs")
        }.sheet(item: $adminUserViewModel.selectedUser) { user in
            UserEditView(user: user) { updatedUser in
                adminUserViewModel.updateUser(updatedUser)}
        }
    
    }
}
