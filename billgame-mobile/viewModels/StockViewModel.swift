import Foundation

@MainActor
class StockViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isEmailValid: Bool = false
    @Published var isEmailVerified: Bool = false
    @Published var messageError: String?
    @Published var merchantUUID: String?
    @Published var availableGames: [Game] = []
    @Published var soldGames: [Game] = []
    @Published var moneyDue: Double?
    @Published var isShowingWithdrawSheet: Bool = false
    @Published var withdrawAmount: String = "0"
    @Published var selectedPaymentMethod: String?
    @Published var selectedGamesToWithdraw: [String] = []
    @Published var withdrawSuccess: Bool = false

    private let userService: UserService = UserService()
    private let stockService: StockService = StockService()
    private let transactionService: TransactionService = TransactionService()

    func validateEmail() {
        isEmailValid = isValidEmail(email)
        if isEmailValid {
            checkMerchantEmail()
        } else {
            messageError = "Format d'email incorrect."
            isEmailVerified = false
        }
    }
    
    func removeGameFromWithdraw(_ etiquette: String) {
        self.selectedGamesToWithdraw.removeAll{$0 == etiquette}
    }
    
    func addGameToWithdraw(_ etiquette: String){
        if !selectedGamesToWithdraw.contains(etiquette){
            selectedGamesToWithdraw.append(etiquette)
        }
    }

    func checkMerchantEmail() {
        userService.getMerchantUUIDByEmail(email: email) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let uuid):
                    self.merchantUUID = uuid
                    self.isEmailVerified = true
                    self.messageError = nil
                    self.fetchSellerGames(sellerUuid: uuid)
                    self.fetchMoneyDue(sellerUuid: uuid)
                case .failure(let error):
                    self.isEmailVerified = false
                    if case .httpError(let statusCode) = error, statusCode == 400 {
                        self.messageError = "L'email du vendeur est incorrect."
                    } else {
                        self.messageError = "Problème avec le serveur."
                    }
                }
            }
        }
    }

    func fetchSellerGames(sellerUuid: String) {
        stockService.getAvailableStockForSeller(sellerUuid: sellerUuid) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let gamesDTO):
                    self.availableGames = gamesDTO.map { Game.fromDTO($0) }
                case .failure:
                    self.messageError = "Erreur lors du chargement des jeux en vente."
                }
            }
        }

        stockService.getSoldGamesForSeller(sellerUuid: sellerUuid) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let gamesDTO):
                    self.soldGames = gamesDTO.map { Game.fromDTO($0) }
                case .failure:
                    self.messageError = "Erreur lors du chargement des jeux vendus."
                }
            }
        }
    }

    func fetchMoneyDue(sellerUuid: String) {
        transactionService.getMoneyDueToSeller(sellerUUID: sellerUuid) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let amount):
                    self.moneyDue = amount
                case .failure:
                    self.moneyDue = nil
                    self.messageError = "Erreur lors du chargement de la somme due."
                }
            }
        }
    }
    
    func withdrawMoney() {
        guard let uuid = merchantUUID else {
            messageError = "Aucun vendeurs n'est spécifiés"
            return
        }
        
        guard let amount = Double(withdrawAmount), amount > 0 else {
            messageError = "Le montant doit être supérieur à zéro."
            return
        }

        guard let paymentMethod = selectedPaymentMethod else {
            messageError = "Veuillez sélectionner un mode de paiement."
            return
        }

        let dto = WithdrawAmountDTO(sellerUuid: uuid, amount: amount, paymentMethod: paymentMethod)

        transactionService.withdrawAmount(dto: dto) { result in
            switch result {
            case .success:
                self.isShowingWithdrawSheet = false
                self.fetchMoneyDue(sellerUuid: uuid)
            case .failure(let error):
                self.messageError = "Erreur lors du retrait: \(error.localizedDescription)"
            }
        }
    }
    
    func refreshStock() {
        guard let uuid = merchantUUID else {
            print("uuid merchant introuvable")
            return
        }
        
        stockService.getAvailableStockForSeller(sellerUuid: uuid) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stockDTOs):
                    self.availableGames = stockDTOs.map { Game.fromDTO($0) }
                case .failure(let error):
                    print("Erreur lors de la mise à jour du stock :", error)
                }
            }
        }
    }
    
    func withdrawSelectedGames() {
        guard let uuid = merchantUUID else {
            print("UUID du marchand introuvable")
            return
        }
        
        print(selectedGamesToWithdraw)
        
        let withdrawDTO = WithdrawGamesDTO(ownerUuid: uuid, labels: selectedGamesToWithdraw)

        stockService.withdrawGames(listOfGamesToWithdraw: withdrawDTO) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.withdrawSuccess = true
                    self.refreshStock()
                case .failure(let error):
                    self.messageError = "Erreur lors du retrait : \(error.localizedDescription)"
                }
            }
        }
    }




    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
