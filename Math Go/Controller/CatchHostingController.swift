import UIKit
import SwiftUI

class CatchHostingController: UIHostingController<AnyView> {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let beastie: Beastie
    
    init?(coder: NSCoder, beastie: Beastie) {
        self.beastie = beastie
        super.init(coder: coder, rootView: AnyView(CatchView(beastie: self.beastie).environmentObject(appDelegate.player)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
