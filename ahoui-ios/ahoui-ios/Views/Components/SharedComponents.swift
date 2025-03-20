import SwiftUI

struct InputLabel: View {
    var title: String
    var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.black)
            Text(text)
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 218, height: 35)
                .background(Color.white.opacity(0.5))
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
        }
    }
}

/*
struct ActionButton: View {
    var title: String
    var color: Color

    var body: some View {
        Button(action: { /* Handle action */ }) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
                .padding()
                .frame(width: 90)
                .background(Color.white.opacity(0.5))
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(color, lineWidth: 1))
        }
    }
}
 */


struct InputFieldClientDetail: View {
    var title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.black)
            TextField("", text: $text)
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 218, height: 35)
                .background(Color.white.opacity(0.5))
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
        }
    }
}


struct InputFieldNewClient: View {
    var title: String
    @Binding var text: String
    var placeholder: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.black)
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 5)
        }
    }
}
