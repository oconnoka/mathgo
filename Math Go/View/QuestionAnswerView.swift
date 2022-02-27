import SwiftUI

struct QuestionAnswerView: View {
    
    @EnvironmentObject var player: Player
    
    // Received from parent view
    @State var beastie: Beastie
    
    @State private var answer: String = ""
    @State private var showResult: Bool = false
    @State private var resultAlert = ResultAlert(title: "", message: "")
    
    var body: some View {
        
        // For going back to Map
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        VStack {
            // Math question
            Text(beastie.mathQuestion.question)
                .questionStyle()
            
            // Answer entry
            HStack {
                TextField("Enter Answer", text: $answer)
                    .numeric()
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
        // Show correct/incorrect popup
        .alert(isPresented: $showResult, content: {
            Alert(
                title: Text(resultAlert.title),
                message: Text(resultAlert.message),
                dismissButton: .default(
                    Text("Ok"),
                    action: { // Go back to Map
                        window?.rootViewController?.dismiss(animated: true)
                    }
                )
            )
        })
    }
    
    func evaluateAnswer() {
        if (answer == String(beastie.mathQuestion.answer)) {
            player.caught(beastie: beastie)
            resultAlert = ResultAlert(title: "Correct!", message: beastie.name + " has been caught")
        } else {
            resultAlert = ResultAlert(title: "Incorrect", message: beastie.name + " got away!")
        }
        showResult = true
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

struct ResultAlert {
    let title: String
    let message: String
}

extension UITextField {
    @objc func toggleMinus() {
        let answerText = self.text ?? ""
        self.text = String(answerText.hasPrefix("-") ? answerText.dropFirst() : "-\(answerText)")
    }
}

struct QuestionAnswerView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionAnswerView(beastie: Beastie.random)
    }
}
