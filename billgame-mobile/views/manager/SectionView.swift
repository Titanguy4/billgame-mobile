import SwiftUI

struct SectionView: View {
    var title: String
    var jeux: [Jeu]
    
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.title3)
                        .foregroundColor(.black)
                }
            }
            .padding(.vertical, 5)

            if isExpanded {
                ForEach(jeux) { jeu in
                    JeuRow(jeu: jeu) // Composant séparé pour un meilleur style
                }
            }
        }
        .padding(.horizontal)
    }
}

struct JeuRow: View {
    var jeu: Jeu
    @State private var isCopied = false // État pour montrer l'animation de copie

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(jeu.nom) - \(jeu.editeur)")
                .font(.headline)
            
            HStack {
                Text("Prix: \(jeu.prix) €")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: {
                    UIPasteboard.general.string = jeu.etiquette
                    isCopied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isCopied = false
                    }
                }) {
                    HStack {
                        Text(isCopied ? "Copié !" : "Copier")
                            .font(.subheadline)
                            .foregroundColor(isCopied ? .green : .gray)
                        Image(systemName: isCopied ? "checkmark.circle.fill" : "doc.on.doc")
                            .foregroundColor(isCopied ? .green : .gray)
                    }
                }
            }

            Text("Étiquette: \(jeu.etiquette)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
