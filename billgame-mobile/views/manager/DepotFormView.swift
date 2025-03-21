import SwiftUI

struct JeuDepot: Identifiable {
    let id = UUID()
    let nom: String
    let editeur: String
    let prix: Int
    let quantite: Int
}

struct DepotFormView: View {
    var email: String
    
    @State private var nom = ""
    @State private var editeur = ""
    @State private var prix = ""
    @State private var quantite = "1"
    @State private var jeuxAjoutes: [JeuDepot] = []

    var body: some View {
        VStack(spacing: 10){
                
            VStack(alignment: .leading, spacing: 10) {
                Text("Déposer un jeu")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)

                VStack(spacing: 10) {
                    CustomTextField(placeholder: "Nom", text: $nom)
                    CustomTextField(placeholder: "Éditeur", text: $editeur)
                    CustomTextField(placeholder: "Prix", text: $prix, isNumber: true)
                    CustomTextField(placeholder: "Quantité", text: $quantite, isNumber: true)
                }

                Button(action: {
                    if let prixInt = Int(prix), let quantiteInt = Int(quantite), !nom.isEmpty, !editeur.isEmpty {
                        let newJeu = JeuDepot(nom: nom, editeur: editeur, prix: prixInt, quantite: quantiteInt)
                        jeuxAjoutes.append(newJeu)

                        // Reset des champs
                        nom = ""
                        editeur = ""
                        prix = ""
                        quantite = "1"
                    }
                }) {
                    Text("Ajouter le jeu")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        
        VStack(spacing: 10) {
            VStack(alignment: .leading) {
                Text("Jeux à déposer")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)

                ForEach(jeuxAjoutes) { jeu in
                    VStack(alignment: .leading) {
                        Text("\(jeu.nom) - \(jeu.editeur)")
                            .font(.headline)
                            .foregroundColor(.black)

                        Text("Prix: \(jeu.prix)€ | Quantité: \(jeu.quantite)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
            }
            .padding()
        }

        // Boutons d'action
        HStack {
            Button(action: {}) {
                Text("Retour")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                // Action pour soumettre le dépôt
            }) {
                Text("Soumettre le dépôt")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding(.top, 10)
    }
}
