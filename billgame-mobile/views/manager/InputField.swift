import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isNumber: Bool = false

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(isNumber ? .numberPad : .default)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
    }
}
