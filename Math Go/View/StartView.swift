import SwiftUI

struct StartView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var player: Player
    
    @State private var name: String = ""
    
    var body: some View {
        VStack {
            // Title
            Text("Create a player")
                .titleTop()
                .padding(.bottom, 20)
            
            // Avatar
            Text("Pick an avatar")
                .headerStyle()
            
            AvatarGridView()
                .padding()
            
            // Name
            Text("Enter a name")
                .headerStyle()
            
            TextField("Username", text: $name)
                .oneLine()
            
            Spacer()
            
            // Start button
            Button("Start") {
                self.player.name = self.name
                self.player.save()
                self.mode.wrappedValue.dismiss() // back to Map screen
            }
            .confirmStyle()
            .disabled(self.name.isEmpty || self.player.avatar.isEmpty)
        }
        .padding()
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(Player.samplePlayer)
    }
}
