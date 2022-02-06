import SwiftUI

struct StartView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var player: Player
    @State private var name = ""
    
    var body: some View {
        VStack {
            Text("Start Screen (Placeholder)")
            Spacer()
            Text("set up player stuff on this screen")
            TextField("Username", text: $name)
            Spacer()
            Button("Start") {
                storePlayer()
                self.mode.wrappedValue.dismiss() // show Map screen
            }
            .disabled(name.isEmpty)
        }
        .padding()
    }
    
    func storePlayer() {
        self.player.name = self.name
        self.player.save()
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
