import SwiftUI

struct StartView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var player: Player
    
    @State private var name: String = ""
    
    var body: some View {
        ScrollView {
            // Title
            Text("Create a player")
                .titleTop()
                .padding(.bottom, 10)
            
            // Avatar
            Text("Pick an avatar")
                .headerStyle()
            
            AvatarGridView()
            
            // Name
            Text("Enter a name")
                .headerStyle()
            
            TextField("Username", text: $name)
                .oneLine()
                .disableAutocorrection(true)
            
            Spacer()
            
            // Start button
            Button("Start") {
                self.player.name = self.name
                self.player.save()
                UserDefaults.standard.set(true, forKey: "playerExists")
                self.mode.wrappedValue.dismiss() // back to Map screen
            }
            .disabled(self.name.isEmpty || self.player.avatar.isEmpty)
        }
        .padding()
        .ignoresSafeArea(.keyboard)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(Player.samplePlayer)
    }
}
