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
    static let sampleData: [Beastie] =
    [
        Beastie(id: 1, name: "MathGO", mathQuestion: MathQuestionGenerator().getQuestion(level: 1)),
        Beastie(id: 2, name: "MathGO", mathQuestion: MathQuestionGenerator().getQuestion(level: 2)),
        Beastie(id: 3, name: "MathGO", mathQuestion: MathQuestionGenerator().getQuestion(level: 3)),
        Beastie(id: 4, name: "MathGO", mathQuestion: MathQuestionGenerator().getQuestion(level: 4)),
        Beastie(id: 5, name: "MathGO", mathQuestion: MathQuestionGenerator().getQuestion(level: 5)),
    ]
    
    static let rando: Beastie = Beastie(id: 1, name: "MathGO", mathQuestion: MathQuestionGenerator().getQuestion(level: Int.random(in: 1...5)))
}
