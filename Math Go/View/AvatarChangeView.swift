import SwiftUI

struct AvatarChangeView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var player: Player
    
    var body: some View {
        VStack {
            Text("Pick an avatar")
                .headerStyle()
            
            AvatarGridView()
            Button("Confirm") {
                player.save()
                self.mode.wrappedValue.dismiss() // back to Map screen
            }
            .disabled(self.player.avatar.isEmpty)
        }
        .interactiveDismissDisabled()
        .onAppear {
            self.player.avatar = ""
        }
        .padding()
    }
}

struct AvatarChangeView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarChangeView().environmentObject(Player.samplePlayer)
    }
}
