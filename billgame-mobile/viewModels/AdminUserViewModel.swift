import Foundation
class AdminUserViewModel: ObservableObject {
    @Published var selectedUser : User? = nil
    @Published var isEditing : Bool = false
    @Published var isUserListLoading = true
    @Published var users: [User]
    private let userService : UserService = UserService()
    
    init () {
        self.users = []
        Task {
            updateUserList()
            isUserListLoading = false
        }
    }
    
    public func updateUserList() {
        Task{
            self.users = await userService.getUserList()
        }
    }
    
    public func updateUser(_ user: User) -> Void {
        guard let index :Int = users.firstIndex(where: {$0.id == user.id}) else {
            return
        }
        users[index] = user
        Task {
            await userService.modifyUser(user)
            sleep(1)
            updateUserList()
        }
    }
    
    public func deleteUser(_ user: User) {
        users.removeAll { $0.id == user.id }
        Task {
            await userService.deleteUser(user)
            sleep(1)
            updateUserList()
        }
    }
    
    public func editUser(_ user: User) {
        selectedUser = user
    }
}
