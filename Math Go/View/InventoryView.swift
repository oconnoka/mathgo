import SwiftUI

struct InventoryView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var player: Player

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        VStack {
            HStack {
                Button("<") {
                    self.mode.wrappedValue.dismiss()
                }
                Spacer()
            }
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(player.beasties, id: \.id) { beastie in
                        BeastieView(beastie: beastie)
                            .padding()
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
