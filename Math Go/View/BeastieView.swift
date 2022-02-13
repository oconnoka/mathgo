import SwiftUI

struct BeastieView: View {

    let beastie: Beastie
    
    init(beastie: Beastie) {
        self.beastie = beastie
    }
    
    var body: some View {
        VStack {
            Image(beastie.name)
                .resizable()
                .scaledToFit()
            Text(beastie.name)
        }
    }
}

struct BeastieView_Previews: PreviewProvider {
    static var previews: some View {
        BeastieView(beastie: Beastie(id: 1, name: Beastie.allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: Int.random(in: 1...5))))
    }
}
