import Foundation
import SwiftUI

struct Beastie: Codable {
    var id: Int
    var name: String
    var mathQuestion: MathQuestion
    
    init(id: Int, name: String, mathQuestion: MathQuestion) {
        self.id = id
        self.name = name
        self.mathQuestion = mathQuestion
    }
}

extension Beastie {
    
    static let allBeasties = [
        "AntBeastie", "BatBeastie", "DarkBeastie", "DragonBeastie", "GreenBeastie",
        "GroundBeastie", "IceBeastie", "MarshieBeastie", "PlantBeastie", "RockBeastie", "UFOBeastie"
    ]
    
    static let sampleData: [Beastie] =
    [
        Beastie(id: 1, name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: 1)),
        Beastie(id: 2, name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: 2)),
        Beastie(id: 3, name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: 3)),
        Beastie(id: 4, name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: 4)),
        Beastie(id: 5, name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: 5)),
    ]
    
    static let random: Beastie = Beastie(id: Int.random(in:1...allBeasties.count), name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: Int.random(in: 1...5)))
}
