import SwiftUI

struct AvatarGridView: View {
    
    @EnvironmentObject var player: Player
    
    @State private var avatarSelected: Int!
    
    let numberOfAvatars = 5
    
    var body: some View {
        LazyVGrid(columns: columns3) {
            ForEach(0 ..< numberOfAvatars) { index in
                Button(
                    action: {
                        self.avatarSelected = index
                        self.player.avatar = "Avatar\(index)"
                    },
                    label: {
                        Image("Avatar\(index)")
                            .fit()
                            .padding(8)
                    })
                    .border(Color.green, width: self.avatarSelected == index ? 5 : 0)
            }
        }
    }
}

struct AvatarGridView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarGridView().environmentObject(Player.samplePlayer)
    }
}
