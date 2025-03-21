import SwiftUI

struct Jeu: Identifiable {
    let id = UUID()
    let nom: String
    let editeur: String
    let prix: Int
    let etiquette: String
}

import SwiftUI

struct SellerStockView: View {
    var email: String
    
    let jeuxEnVente: [Jeu] = [
        Jeu(nom: "Dragon’s Quest", editeur: "Fantasy Games", prix: 30, etiquette: "c6cc57a8-beab-4c44-aed3-82bb02b0cfac"),
        Jeu(nom: "Dragon’s Quest", editeur: "Fantasy Games", prix: 30, etiquette: "15da6ae9-d346-4917-86a7-2089ddbe665d")
    ]

    let jeuxVendus: [Jeu] = [
        Jeu(nom: "Dragon’s Quest", editeur: "Fantasy Games", prix: 30, etiquette: "86097553-6346-419d-b98b-de608ef1a670")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Stock du vendeur")
                    .font(.largeTitle)
                    .bold()

                Text(email)
                    .font(.headline)
                    .foregroundColor(.gray)

                HStack(spacing: 10) {
                    StatCard(title: "Jeux en vente", value: "\(jeuxEnVente.count)")
                    StatCard(title: "Jeux vendus", value: "\(jeuxVendus.count)")
                }

                SectionView(title: "Jeux en vente", jeux: jeuxEnVente)
                SectionView(title: "Jeux vendus", jeux: jeuxVendus)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("Stock", displayMode: .inline)
    }
}

