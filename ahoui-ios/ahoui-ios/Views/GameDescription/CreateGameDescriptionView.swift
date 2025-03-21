import SwiftUI

struct CreateGameDescriptionView: View {
    @ObservedObject var viewModel: GameDescriptionViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var publisher = ""
    @State private var description = ""
    @State private var photoURL = ""
    @State private var minPlayers = 0
    @State private var maxPlayers = 0
    @State private var ageRange = "18+"

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showConfirmationDialog = false
    @State private var isSubmitting = false

    let ageRanges = ["0-5", "5-10", "8-12", "12-18", "18+"]

    var body: some View {
        ZStack {
            Color(red: 1, green: 0.965, blue: 0.922)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                Text("Créer un nouveau jeu")
                    .font(.custom("Poppins-SemiBold", size: 25))
                    .foregroundColor(.black)
                    .padding(.bottom, 20)

                Group {
                    customTextField("Nom du jeu", text: $name)
                    customTextField("Éditeur", text: $publisher)
                    customTextField("URL de la photo", text: $photoURL)
                    customTextEditor("Description du jeu", text: $description)
                        .frame(height: 120)

                    customStepperField("Nombre min de joueurs", value: $minPlayers, range: 0...20)
                    customStepperField("Nombre max de joueurs", value: $maxPlayers, range: minPlayers...20)
                }

                Picker(selection: $ageRange, label: pickerLabel("Tranche d’âge")) {
                    ForEach(ageRanges, id: \.self) { age in
                        Text(age).tag(age)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 180, height: 42)
                .background(Color.white.opacity(0.5))
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))

                Spacer()

                Button(action: { showConfirmationDialog = true }) {
                    Text("CREER")
                        .foregroundColor(.white)
                        .font(.custom("Poppins-Bold", size: 18))
                        .frame(width: 140, height: 49)
                        .background(isSubmitting ? Color.gray : Color.blue)
                        .cornerRadius(15)
                }
                .padding(.top, 10)
                .disabled(isSubmitting)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .confirmationDialog("Voulez-vous vraiment créer ce jeu ?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                    Button("Créer", role: .none) {
                        createGame()
                    }
                    Button("Annuler", role: .cancel) {}
                }

            }
            .padding(.horizontal, 30)
            .padding(.top, 30)
        }
    }

    // MARK: - Subviews Helpers

    func customTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .padding()
            .font(.custom("Poppins-ExtraLightItalic", size: 15))
            .background(Color.white.opacity(0.5))
            .cornerRadius(4)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
            .foregroundColor(.black)
    }

    func customTextEditor(_ placeholder: String, text: Binding<String>) -> some View {
        ZStack(alignment: .topLeading) {
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .font(.custom("Poppins-ExtraLightItalic", size: 15))
                    .foregroundColor(.gray)
                    .padding(8)
            }
            TextEditor(text: text)
                .font(.custom("Poppins-ExtraLightItalic", size: 15))
                .padding(4)
                .background(Color.clear)
        }
        .background(Color.white.opacity(0.5))
        .cornerRadius(4)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
    }

    func customStepperField(_ title: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        HStack {
            Text(title)
                .font(.custom("Poppins-ExtraLightItalic", size: 15))
            Spacer()
            HStack(spacing: 8) {
                Button(action: {
                    if value.wrappedValue > range.lowerBound {
                        value.wrappedValue -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(value.wrappedValue > range.lowerBound ? .blue : .gray)
                        .font(.system(size: 24))
                }
                Text("\(value.wrappedValue)")
                    .frame(width: 40)
                    .font(.custom("Poppins", size: 17))
                    .multilineTextAlignment(.center)
                Button(action: {
                    if value.wrappedValue < range.upperBound {
                        value.wrappedValue += 1
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(value.wrappedValue < range.upperBound ? .blue : .gray)
                        .font(.system(size: 24))
                }
            }
        }
        .padding()
        .frame(height: 43)
        .background(Color.white.opacity(0.5))
        .cornerRadius(4)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black, lineWidth: 1))
    }

    func pickerLabel(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.custom("Poppins-ExtraLightItalic", size: 15))
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundColor(.black)
        }
        .padding(.horizontal)
    }

    // MARK: - Validation & Actions

    func validateFields() -> Bool {
        if name.isEmpty || publisher.isEmpty || description.isEmpty || photoURL.isEmpty {
            alertMessage = "Veuillez remplir tous les champs."
            return false
        }
        if !isValidURL(photoURL) {
            alertMessage = "L'URL de la photo n'est pas valide."
            return false
        }
        if minPlayers == 0 || maxPlayers == 0 {
            alertMessage = "Le nombre de joueurs ne peut pas être 0."
            return false
        }
        return true
    }

    func createGame() {
        guard validateFields() else {
            showAlert = true
            return
        }

        isSubmitting = true

        let gameCreation = GameDescriptionCreation(
            name: name,
            publisher: publisher,
            description: description,
            photoURL: photoURL,
            minPlayers: minPlayers,
            maxPlayers: maxPlayers,
            ageRange: ageRange
        )

        viewModel.createGame(description: gameCreation) { success in
            isSubmitting = false
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                alertMessage = "Erreur lors de la création du jeu."
                showAlert = true
            }
        }
    }

    func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    
}
