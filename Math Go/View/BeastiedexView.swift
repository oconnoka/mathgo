import SwiftUI

struct BeastiedexView: View {
    
    @EnvironmentObject var player: Player
    
    @State var caughtBeasties = Set<String>()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns3) {
                ForEach(Beastie.allBeasties.indices) { idx in
                    BeastieView(beastie: Beastie(id: idx + 1,
                                                 name: Beastie.allBeasties[idx],
                                                 mathQuestion: MathQuestion.blank,
                                                 location: coordinateOne),
                                showSilhouette: caughtBeasties.contains(Beastie.allBeasties[idx]) ? false : true)
                        .frame(height: 100)
                        .padding()
                }
            }
        }
        .onAppear { getCaughtBeasties() }
    }
    
    func getCaughtBeasties() {
        for beastie in self.player.beasties {
            caughtBeasties.insert(beastie.name)
        }
    }
}

struct BeastiedexView_Previews: PreviewProvider {
    static var previews: some View {
        BeastiedexView().environmentObject(Player.samplePlayer)
    }
}
