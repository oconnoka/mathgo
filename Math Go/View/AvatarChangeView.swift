import SwiftUI

struct AvatarChangeView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var player: Player
    
    var body: some View {
        VStack {
            Text("Pick an avatar").headerStyle()
            AvatarGridView()
            Spacer()
        }
        .padding()
    }
}

struct AvatarChangeView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarChangeView().environmentObject(Player.samplePlayer)
    }
}
