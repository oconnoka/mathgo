import SwiftUI

struct InventoryView: View {
    
    @EnvironmentObject var player: Player
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns3) {
                ForEach(player.beasties, id: \.id) { beastie in
                    BeastieView(beastie: beastie)
                        .frame(height: 100)
                        .padding()
                }
            }
            .padding()
        }
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView().environmentObject(Player.samplePlayer)
    }
}
