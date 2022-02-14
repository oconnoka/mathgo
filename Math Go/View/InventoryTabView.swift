import SwiftUI

struct InventoryTabView: View {
    
    @EnvironmentObject var player: Player
    
    var body: some View {
        TabView {
            InventoryView().tabItem { Text("Inventory") }.tag(1)
            BeastiedexView().tabItem { Text("Beastiedex") }.tag(2)
        }
    }
}

struct InventoryTabView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryTabView().environmentObject(Player.samplePlayer)
    }
}
