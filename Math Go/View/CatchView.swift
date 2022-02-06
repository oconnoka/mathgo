import SwiftUI
import Introspect

struct CatchView: View {
    
    let beastie: Beastie
    
    init(beastie: Beastie) {
        self.beastie = beastie
    }

    // To go back to Map screen
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var player: Player

    @State private var answer: String = ""
    @State private var arModeOn = false
    @State private var resultAlert: ResultAlert?

    var body: some View {
        VStack(alignment: .center) {
            
            // Top bar
            HStack {
                Button("< Run Away") {
                    self.mode.wrappedValue.dismiss()
                }
                Spacer()
                Toggle("AR Mode", isOn: $arModeOn)
                    .frame(width: 130)
            }
            Spacer()
            
            // Beastie image
            Image(beastie.name)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            Spacer()
            
            // Math question
            Text(beastie.mathQuestion.question)
                .font(.system(size: 24))
                .lineLimit(1)
            
            // Answer entry
            HStack {
                TextField("Enter Answer", text: $answer)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24))
                    .lineLimit(1)
                    .frame(width: 200)
                    .introspectTextField {
                        textField in textField.becomeFirstResponder()
                    }
                    .introspectTextField(customize: keyboardToolbar)
                Button("Submit") {
                    evaluateAnswer()
                }
                .disabled(answer.isEmpty)
            }
            
        }
        .padding()
        
        // Show correct/incorrect popup
        .alert(item: $resultAlert) { result in
            Alert(
                title: Text(result.title),
                message: Text(result.message),
                dismissButton: .default(
                    Text("Ok"),
                    action: { // Go back to Map
                        self.mode.wrappedValue.dismiss()
                    }
                )
            )
        }
    }
    
    func evaluateAnswer() {
        if (answer == String(self.beastie.mathQuestion.answer)) {
            player.caught(beastie: beastie)
            resultAlert = ResultAlert(title: "Correct!", message: beastie.name + " has been caught")
        } else {
            resultAlert = ResultAlert(title: "Incorrect", message: beastie.name + " got away!")
        }
    }
    
    // +/- button to make answer negative
    func keyboardToolbar(to textField: UITextField) {
        let toolbar = UIToolbar(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: textField.frame.size.width, height: 44)
            )
        )

        let plusMinus = UIBarButtonItem(
            title: "+/-",
            style: .plain,
            target: self,
            action: #selector(textField.toggleMinus))
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil)

        toolbar.setItems([flexSpace, plusMinus, flexSpace], animated: true)
        toolbar.sizeToFit()
        
        textField.inputAccessoryView = toolbar
    }
}

extension UITextField {
    @objc func toggleMinus() {
        let answerText = self.text ?? ""
        self.text = String(answerText.hasPrefix("-") ? answerText.dropFirst() : "-\(answerText)")
    }
}

struct ResultAlert: Identifiable {
    var id: String { title }
    let title: String
    let message: String
}

struct CatchView_Previews: PreviewProvider {
    static var previews: some View {
        CatchView(beastie: Beastie.rando)
    }
}
