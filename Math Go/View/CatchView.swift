import SwiftUI
import Introspect

struct CatchView: View {
    
    let mathQuestion: MathQuestion
    
    init(mathQuestion: MathQuestion) {
        self.mathQuestion = mathQuestion
    }
    
    @State private var answer: String = ""
    @State private var arModeOn = false
    
    // To go back to previous screen
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
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
            Image("MathGO")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            Spacer()
            
            // Math question
            Text(mathQuestion.question)
                .font(.system(size: 24))
                .lineLimit(1)
            
            // Answer entry
            TextField("Enter Answer", text: $answer)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .font(.system(size: 24))
                .lineLimit(1)
                .frame(width: 200)
                .introspectTextField {
                    textField in textField.becomeFirstResponder()
                }
                .introspectTextField(customize: addDoneToolbar)
            
        }
        .padding()
    }
    
    func addDoneToolbar(to textField: UITextField) {
        let doneToolbar = UIToolbar(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: textField.frame.size.width, height: 44)
            )
        )
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(
            title: "Submit",
            style: .done,
            target: self,
            action: #selector(textField.doneButtonAction(_: ))
        )
        
        doneToolbar.setItems([flexSpace, doneButton], animated: true)
        textField.inputAccessoryView = doneToolbar
    }
}

extension UITextField {
    @objc func doneButtonAction(_ button: UIBarButtonItem) -> Void {
        let answer = self.text ?? ""
        print(answer) // TODO - evaluate answer
        resignFirstResponder()
    }
}

struct CatchView_Previews: PreviewProvider {
    static var previews: some View {
        CatchView(mathQuestion: MathQuestionGenerator().getQuestion(level: Int.random(in: 1...5)))
    }
}
