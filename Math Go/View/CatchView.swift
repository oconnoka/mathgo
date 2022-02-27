import SwiftUI
import Introspect

struct CatchView: View {
    
    @EnvironmentObject var player: Player
    
    // Pass to child views
    @Binding var beastie: Beastie
    
    var body: some View {
        VStack {
            // Top bar and Beastie
            if player.arModeOn {
                ZStack {
                    ARView(beastie: beastie)
                    VStack {
                        CatchViewTopBar()
                        Spacer()
                    }
                }
            } else {
                CatchViewTopBar()
                Text(beastie.name)
                Image(beastie.name)
                    .fit()
                    .frame(width: 120, height: 120)
                Spacer()
            }
            Spacer()
            
            // Question, answer field, and keyboard
            QuestionAnswerView(beastie: beastie)
            Spacer()
        }
    }
}

struct CatchViewTopBar: View {
    // To go back to Map
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var player: Player
    
    var body: some View {
        HStack {
            Button("< Run Away") {
                self.mode.wrappedValue.dismiss()
            }
            Spacer()
            Toggle(isOn: $player.arModeOn) {
                Text("AR Mode")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
    }
}

struct CatchView_Previews: PreviewProvider {
    static var previews: some View {
        CatchView(beastie: .constant(Beastie.random)).environmentObject(Player.samplePlayer)
    }
}
