import UIKit
import SwiftUI

class AvatarChangeHostingController: UIHostingController<AnyView> {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AnyView(AvatarChangeView().environmentObject(appDelegate.player)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Might be able to do something here to update profile screen avatar?
    }
}
