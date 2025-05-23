import Foundation

enum DepotState {
    case idle
    case success(String)
    case failure(String)
}

@MainActor
class DepotViewModel: ObservableObject {
    @Published var gamesToDeposit: [GameWithStock] = []
    @Published var email: String = "" {
        didSet {
            validateEmail()
        }
    }
    @Published var isEmailValid: Bool = false
    @Published var isEmailVerified: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var merchantUUID: String?
    @Published var depotState: DepotState = .idle
    @Published var selectedEditor: String = ""
    @Published var sellerName: String = ""
    @Published var sellerPhone: String = ""
    @Published var sellerPassword: String = ""
    @Published var sellerDiscount: String = "0"

    private let userService: UserService
    private let stockService: StockService
    private let gameService: GameService

    init(userService: UserService = UserService(), stockService: StockService = StockService(), gameService: GameService = GameService()) {
        self.userService = userService
        self.stockService = stockService
        self.gameService = gameService
    }
    
    func createSeller() {
        guard isEmailValid else {
            errorMessage = "Veuillez entrer un email valide."
            return
        }

        let newSeller = SellerDTO(
            uuid: UUID().uuidString,
            name: sellerName,
            email: email,
            phone: sellerPhone,
            roles: ["MERCHANT"],
            password: sellerPassword,
            discount: Double(sellerDiscount) ?? 0.0
        )

        isLoading = true
        userService.createSeller(sellerDTO: newSeller) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    self.errorMessage = nil
                    self.depotState = .success("Vendeur créé avec succès !")
                case .failure:
                    self.errorMessage = "Erreur lors de la création du vendeur"
                }
            }
        }
    }


    
    func fetchEditor(for gameName: String) {
        gameService.getEditorByGame(gameName: gameName) { editorDTO in
            DispatchQueue.main.async {
                self.selectedEditor = editorDTO?.name ?? "Éditeur inconnu"
            }
        }
    }


    func addGame(nom: String, editeur: String, prix: String, quantite: String) {
        guard let prixDouble = Double(prix), let quantiteInt = Int(quantite) else {
            depotState = .failure("Le prix et la quantité doivent être valides.")
            return
        }

        guard let ownerUUID = merchantUUID else {
            depotState = .failure("UUID du vendeur introuvable.")
            return
        }

        let newGame = GameWithStock(
            name: nom,
            editor: editeur,
            price: prixDouble,
            stock: quantiteInt,
            owner_uuid: ownerUUID
        )

        gamesToDeposit.append(newGame)
        depotState = .success("Jeu ajouté au dépôt !")
    }

    func submitDeposit() {
        guard let uuidSeller = merchantUUID else {
            depotState = .failure("UUID du vendeur manquant.")
            return
        }
        
        guard !gamesToDeposit.isEmpty else {
            depotState = .failure("Aucun jeu à déposer.")
            return
        }

        let stockDTOs = gamesToDeposit.map { $0.toDTO() }
        let deposit = DepositDTO(
            uuidSeller: uuidSeller,
            stocks: stockDTOs,
            paymentMethod: "Cash",
            isPublished: true
        )
        stockService.postDeposit(deposit: deposit, publish: true) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let depositId):
                    self.depotState = .success("Voici les frais de dépôts: \(depositId)")
                    self.gamesToDeposit.removeAll()
                case .failure(let error):
                    self.depotState = .failure("Échec du dépôt: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func removeGame(at index: Int) {
        guard index >= 0 && index < gamesToDeposit.count else { return }
        gamesToDeposit.remove(at: index)
        depotState = .success("Jeu supprimé du dépôt.")
    }



    func validateEmail() {
        isEmailValid = isValidEmail(email)
        if !isEmailValid {
            errorMessage = "Format d'email incorrect."
            isEmailVerified = false
        } else {
            errorMessage = nil
        }
    }

    func checkMerchantEmail() {
        guard isEmailValid else { return }

        isLoading = true

        userService.getMerchantUUIDByEmail(email: email) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let uuid):
                    self.merchantUUID = uuid
                    self.isEmailVerified = true
                    self.errorMessage = nil
                case .failure(let error):
                    if case .httpError(let statusCode) = error, statusCode == 400 {
                        self.errorMessage = "L'email du vendeur est incorrect."
                    } else {
                        self.errorMessage = "Problème avec le serveur"
                    }
                    self.isEmailVerified = false
                }
            }
        }
    }


    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
