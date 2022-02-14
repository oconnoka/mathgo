import Foundation
import SwiftUI
import UIKit

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
    
    // Removes "Beastie" from display name text
    init(beastieName: String) {
        if beastieName.count < "Beastie".count {
            self.init(" ")
        } else {
            self.init(beastieName.dropLast("Beastie".count))
        }
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

extension Color {
    static let silhouetteGray = Color(red: 95/255, green: 98/255, blue: 103/255)
}

extension Image {
    func fit() -> some View {
        self
            .resizable()
            .scaledToFit()
    }
    
    func silhouette() -> some View {
        self
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.silhouetteGray)
            .scaledToFit()
    }
}

/* Resizes UIImage without scretching
 Source: https://www.advancedswift.com/resize-uiimage-no-stretching-swift/ */
extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
    
    // Helper method to scale a UIImage
    static func scaleImage(imageName: String, size: Int) -> UIImage {
        let pinImage = UIImage(named: imageName)
        let targetSize = CGSize(width: size, height: size)
        let scaledImage = pinImage?.scalePreservingAspectRatio(targetSize: targetSize)
        return scaledImage ?? UIImage()
    }
}
