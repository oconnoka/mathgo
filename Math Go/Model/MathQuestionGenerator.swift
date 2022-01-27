import Foundation

class MathQuestionGenerator {

    let levels = [
        Level(operations: ["+"], numOperations: 1, minValue: 0, maxValue: 9),
        Level(operations: ["+", "-"], numOperations: 2, minValue: -9, maxValue: 9),
        Level(operations: ["+", "-", "*", "/"], numOperations: 2, minValue: -9, maxValue: 9),
        Level(operations: ["+", "-", "*", "/"], numOperations: 2, minValue: -99, maxValue: 99),
        Level(operations: ["+", "-", "*", "/"], numOperations: 4, minValue: -99, maxValue: 99)
    ]

    func getQuestion (level: Int) -> MathQuestion {
        let q = levels[level - 1] // levels array is 0-indexed
        
        func randomNumber() -> Int {
            return Int.random(in: q.minValue...q.maxValue)
        }

        // to ensure a whole number after division, multiply the previous number by divisor
        func handleDivision() {
            let divisor = randomNumber()
            var dividend = question.popLast()!
            dividend = String(Int(dividend)! * divisor)
            question.append(dividend)
            question.append("/")
            question.append(String(divisor))
        }

        // start question array with a number
        var question = [String(randomNumber())]

        // append random operation and number for each operation
        for _ in 1...q.numOperations {
            let operation = q.operations.randomElement()!

            if (operation == "/") {
                handleDivision()
            } else {
                question.append(operation)
                question.append(String(randomNumber()))
            }
        }

        /* Note: questionString format is like this: -17 * -3230 / -38 + 37 * 1
                expression format has parenthese: ((-17 * -3230) / -38) + (37 * 1)
         It could be nice to display the expression format, but it takes away from testing
         the player's knowledge of order of operations.
         */
        let questionString = question.joined(separator: " ")
        let expression = NSExpression(format: questionString)
        let answer = expression.expressionValue(with: nil, context: nil) as? Int ?? Int.max

        return MathQuestion(question: questionString, answer: answer, level: level)
    }

}
