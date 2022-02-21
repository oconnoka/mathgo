import SwiftUI

struct BeastieView: View {
    
    var showSilhouette: Bool = false
    
    let beastie: Beastie
    
    init(beastie: Beastie) {
        self.beastie = beastie
    }
    
    init(beastie: Beastie, showSilhouette: Bool) {
        self.beastie = beastie
        self.showSilhouette = showSilhouette
    }
    
    var body: some View {
        VStack {
            if self.showSilhouette {
                Image(beastie.name)
                    .silhouette()
                Spacer()
                Text(beastieName: " ")
            } else {
                Image(beastie.name)
                    .fit()
                Spacer()
                Text(beastieName: beastie.name)
            }
        }
    }
}

struct BeastieView_Previews: PreviewProvider {
    static var previews: some View {
        BeastieView(beastie: Beastie(id: 1, name: Beastie.allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: Int.random(in: 1...5)), location: coordinateOne), showSilhouette: false)
    }
}
