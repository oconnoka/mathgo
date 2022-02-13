import Foundation
import SwiftUI

/* Global Styles */

let columns3: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

extension Button {
    func confirmStyle() -> some View {
        self
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

extension Text {
    func titleTop() -> some View {
        self
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    func headerStyle() -> some View {
        self
            .font(.title3)
            .fontWeight(.medium)
    }
    
    func questionStyle() -> some View {
        self
            .font(.system(size: 24))
            .lineLimit(1)
    }
}

extension TextField {
    func oneLine() -> some View {
        self
            .frame(width: 200, alignment: .center)
            .textFieldStyle(.roundedBorder)
            .font(.system(size: 18))
            .lineLimit(1)
    }
    
    func numeric() -> some View {
        self
            .frame(width: 200)//, alignment: .center)
            .textFieldStyle(.roundedBorder)
            .font(.system(size: 24))
            .lineLimit(1)
            .keyboardType(.numberPad)
    }
}

extension Image {
    func fit() -> some View {
        self
            .resizable()
            .scaledToFit()
    }
}
