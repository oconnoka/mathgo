import Foundation
import SwiftUI

class Player: ObservableObject, Codable {
    @Published var name: String = ""
    @Published var avatar: String = ""
    @Published var beasties: [Beastie] = [Beastie]()
    @Published var mathLevel: Int = 1
    @Published var questionsCorrect: Int = 0

    func save() {
        try? UserDefaults.standard.setObject(self, forKey: "player")
    }

    func caught(beastie: Beastie) {
        self.beasties.append(beastie)
        self.questionsCorrect += 1
        self.mathLevel = min(self.questionsCorrect / 10 + 1, 5)
        self.save()
    }
    
    /* Encode/Decode Player object for storage
       Source: https://www.hackingwithswift.com/books/ios-swiftui/encoding-an-observableobject-class */
    enum PlayerKeys: CodingKey {
        case name, avatar, beasties, mathLevel, questionsCorrect
    }

    init() { }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PlayerKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(beasties, forKey: .beasties)
        try container.encode(mathLevel, forKey: .mathLevel)
        try container.encode(mathLevel, forKey: .mathLevel)
        try container.encode(questionsCorrect, forKey: .questionsCorrect)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PlayerKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        avatar = try container.decode(String.self, forKey: .avatar)
        beasties = try container.decode([Beastie].self, forKey: .beasties)
        mathLevel = try container.decode(Int.self, forKey: .mathLevel)
        questionsCorrect = try container.decode(Int.self, forKey: .questionsCorrect)
    }
}

extension Player {
    static let samplePlayer: Player = { () -> Player in
        let player = Player()
        player.beasties = Beastie.sampleData
        return player
    }()
}
