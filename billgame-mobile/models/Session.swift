import Foundation

/// `Session` est une structure représentant une session qui contient des informations sur les dates importantes (dépôt, vente), les frais, les commissions, et l'adresse.
struct Session: Identifiable {
    let id: String
    var debutSession: Date
    var finSession: Date
    var debutDepot: Date
    var finDepot: Date
    var debutVente: Date
    var finVente: Date
    var commission: Double
    var areCommissionPercentage : Bool
    var fraisDepot: Double
    var isDepositFeePercentage : Bool
    var adresse: String
    
    // Initialiseur classique
        /// L'initialiseur permet de créer une session avec toutes les propriétés nécessaires.
        /// - Parameters:
        ///   - id: L'identifiant unique de la session.
        ///   - ds: La date de début de la session.
        ///   - fs: La date de fin de la session.
        ///   - dd: La date de début du dépôt.
        ///   - fd: La date de fin du dépôt.
        ///   - dv: La date de début de la vente.
        ///   - fv: La date de fin de la vente.
        ///   - com: Le montant de la commission.
        ///   - fraisDep: Le montant des frais de dépôt.
        ///   - adresse: L'adresse associée à la session.
        ///   - isDepositFeePercentage: Indique si les frais de dépôt sont en pourcentage.
        ///   - areCommissionPercentage: Indique si la commission est en pourcentage.
    init(id: String, ds: Date, fs: Date, dd: Date, fd: Date, dv: Date, fv: Date, com: Double, fraisDep: Double, adresse: String, isDepositFeePercentage: Bool, areCommissionPercentage: Bool) {
        self.id = id
        self.debutSession = ds
        self.finSession = fs
        self.debutDepot = dd
        self.finDepot = fd
        self.debutVente = dv
        self.finVente = fv
        self.commission = com
        self.fraisDepot = fraisDep
        self.adresse = adresse
        self.isDepositFeePercentage = isDepositFeePercentage
        self.areCommissionPercentage = areCommissionPercentage
    }
    
    // Initialisation à partir d'un `SessionDTO`
        /// L'initialiseur convertit un objet `SessionDTO` en un modèle `Session`.
        /// - Parameter dto: Le `SessionDTO` à convertir.
    init(from dto: SessionDTO) {
        // Initialisation sécurisée de toutes les propriétés avant d'appeler des méthodes
        self.id = dto.uuid ?? ""
        self.commission = dto.commission
        self.fraisDepot = dto.depositFees
        self.adresse = dto.adresse
        self.isDepositFeePercentage = dto.areDepositFeesPercentage
        self.areCommissionPercentage = dto.isCommissionPercentage
        
        // Initialisation temporaire des dates avec `Date()`
        let defaultDate = Date()
        self.debutSession = defaultDate
        self.finSession = defaultDate
        self.debutDepot = defaultDate
        self.finDepot = defaultDate
        self.debutVente = defaultDate
        self.finVente = defaultDate
        
        // Mettre à jour les dates après l'initialisation
        if let date = dateFromString(dto.startDepositDate) {
            self.debutSession = date
        }
        if let date = dateFromString(dto.endSellDate) {
            self.finSession = date
        }
        if let date = dateFromString(dto.startDepositDate) {
            self.debutDepot = date
        }
        if let date = dateFromString(dto.endDepositDate) {
            self.finDepot = date
        }
        if let date = dateFromString(dto.startSellDate) {
            self.debutVente = date
        }
        if let date = dateFromString(dto.endSellDate) {
            self.finVente = date
        }
    }
    
    // Méthode pour convertir une chaîne de caractères en Date
    /// Cette méthode convertit une chaîne de caractères (au format ISO 8601) en une instance de `Date`.
    /// - Parameter dateString: La chaîne de caractères représentant la date.
    /// - Returns: La `Date` correspondante ou nil si la conversion échoue.
    private func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
        return dateFormatter.date(from: dateString)
    }
    
    // Méthode pour convertir une Date en chaîne de caractères
    /// Cette méthode convertit une instance de `Date` en une chaîne de caractères (format ISO 8601).
    /// - Parameter date: La `Date` à convertir.
    /// - Returns: La chaîne de caractères représentant la date.
    private func stringFromDate(_ date: Date) -> String {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.string(from: date)
    }
    
    // Méthode pour convertir une `Session` en `SessionDTO`
    /// Cette méthode convertit le modèle `Session` en un objet `SessionDTO`.
    /// - Returns: Un objet `SessionDTO` représentant la session.
    func toDTO() -> SessionDTO {
        return SessionDTO(
            uuid: self.id == "newSession" ? nil : self.id,  // Si l'ID est "newSession", il est passé à nil.
            adresse: self.adresse,
            startDepositDate: stringFromDate(self.debutDepot),
            endDepositDate: stringFromDate(self.finDepot),
            startSellDate: stringFromDate(self.debutVente),
            endSellDate: stringFromDate(self.finVente),
            depositFees: self.fraisDepot,
            areDepositFeesPercentage: self.isDepositFeePercentage,
            commission: self.commission,
            isCommissionPercentage: self.areCommissionPercentage
        )
    }
}
