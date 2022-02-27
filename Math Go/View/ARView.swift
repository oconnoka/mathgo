import SwiftUI

struct ARView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ARViewController
    
    var beastie: Beastie
    
    func makeUIViewController(context: Context) -> ARViewController {
        let vc = ARViewController()
        vc.beastie = self.beastie
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ARView.UIViewControllerType,
                                context: UIViewControllerRepresentableContext<ARView>) {
    }
}
