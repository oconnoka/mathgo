import ARKit

/* Source: https://blog.devgenius.io/implementing-ar-in-swiftui-without-storyboards-ec529ace7ab2 */

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    var beastie: Beastie?
    
    var arScnView: ARSCNView {
        return self.view as! ARSCNView
    }
    
    override func loadView() {
        self.view = ARSCNView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arScnView.delegate = self
        arScnView.scene = SCNScene()
    }
    
    // Set anchor distance from camera
    func addAnchor(distance: Float) {
        // Try until cameraTransform is available
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if let cameraTransform = self.arScnView.session.currentFrame?.camera.transform {
                /* Source: https://www.youtube.com/watch?v=nbmjet9-cQ0 */
                var translation = matrix_identity_float4x4
                translation.columns.3.z = distance
                let transform = simd_mul(cameraTransform, translation)
                let anchor = ARAnchor(transform: transform)
                self.arScnView.session.add(anchor: anchor)
                timer.invalidate()
            }
        }
    }
    
    /* Source: https://www.youtube.com/watch?v=nbmjet9-cQ0 */
    // Shows Beastie once anchor is in place
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let beastieNode = createBeastieNode()
        node.addChildNode(beastieNode)
    }
    
    func createBeastieNode() -> SCNNode {
        let scaledBeastie = UIImage.scaleImage(imageName: beastie!.name, size: 120)
        let plane = SCNPlane(width: scaledBeastie.size.width / 1000,
                             height: scaledBeastie.size.height / 1000)
        plane.firstMaterial!.diffuse.contents = scaledBeastie
        let beastieNode = SCNNode(geometry: plane)
        beastieNode.constraints = [SCNBillboardConstraint()] // image always faces camera
        return beastieNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        arScnView.session.run(configuration)
        arScnView.delegate = self
        
        // Set anchor distance away from camera
        addAnchor(distance: -0.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arScnView.session.pause()
    }
}
