import Foundation

class MathQuestion: Codable {
    let question: String
    let answer: Int
    let level: Int
    
    init(question: String, answer: Int, level: Int) {
        self.question = question
        self.answer = answer
        self.level = level
    }
}

extension MathQuestion {
    static let blank: MathQuestion = MathQuestion(question: "", answer: 0, level: 1)
}

struct Level {
    let operations: Array<String>
    let numOperations: Int
    let minValue: Int
    let maxValue: Int
}
