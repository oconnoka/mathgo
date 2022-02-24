import Foundation
import ARKit
import SwiftUI

struct ARView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var arModeOn = true
    
    var body: some View {
        
        ZStack {
            NavigationIndicator()
            VStack(alignment: .center) {
                
                // Top bar
                HStack {
                    // TODO - make this go to Map screen
                    // Button("< Run Away") {
                    //     self.mode.wrappedValue.dismiss()
                    // }
                    Spacer()
                    Toggle("AR Mode", isOn: $arModeOn)
                        .frame(width: 130)
                        .onChange(of: arModeOn, perform: { _ in
                            self.mode.wrappedValue.dismiss()
                        })
                }
                Spacer()
            }
        }
        .padding()
    }
}
