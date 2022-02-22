import Foundation
import SwiftUI
import CoreLocation

struct Beastie: Codable {
    var id: Int
    var name: String
    var mathQuestion: MathQuestion
    var location: Coordinate
    
    init(id: Int, name: String, mathQuestion: MathQuestion, location: Coordinate) {
        self.id = id
        self.name = name
        self.mathQuestion = mathQuestion
        self.location = location
    }
}

let coordinateOne = Coordinate(latitude: 37.7856479, longitude: -122.4196999)
let coordinateTwo = Coordinate(latitude: 37.7850798, longitude: -122.4055807)
let coordinateThree = Coordinate(latitude: 37.7868914, longitude: -122.4046484)
let coordinateFour = Coordinate(latitude: 37.7856437, longitude: -122.4043791)
let coordinateFive = Coordinate(latitude: 37.7866357, longitude: -122.4052481)

extension Beastie {
    
    static let allBeasties = [
        "AntBeastie", "BatBeastie", "DarkBeastie", "DragonBeastie", "GreenBeastie",
        "GroundBeastie", "IceBeastie", "MarshieBeastie", "PlantBeastie", "RockBeastie", "UFOBeastie"
    ]
    
    static let sampleData: [Beastie] =
    [
        Beastie(id: 1, name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: 1), location: coordinateOne),
        Beastie(id: 2, name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: 2), location: coordinateTwo),
        Beastie(id: 3, name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: 3), location: coordinateThree),
        Beastie(id: 4, name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: 4), location: coordinateFour),
        Beastie(id: 5, name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: 5), location: coordinateFive),
    ]
    
    // TO DO: Need to add random location generator as parameter in this function
    static let random: Beastie = Beastie(id: Int.random(in:1...allBeasties.count), name: allBeasties.randomElement()!, mathQuestion: MathQuestionGenerator().getQuestion(level: Int.random(in: 1...5)), location: coordinateOne)
}
