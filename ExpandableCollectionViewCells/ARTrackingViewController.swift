//
//  ARTrackingViewController.swift
//  ExpandableCollectionViewCells
//
//  Created by Saransh Mittal on 02/02/19.
//  Copyright © 2019 dantish. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

@available(iOS 12.0, *)
class ARTrackingViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var debugTextView: UITextView!
    
    var Nodes = [SCNNode]()
    var closestResults = [ARHitTestResult]()
    var detectedObjectCode = [String]()
    var totalLength = 0
    
    func changeNodeText(text:String, number:Int){
        Nodes[number].removeFromParentNode()
        Nodes.remove(at: number)
        var closestResult = closestResults[number]
        let transform : matrix_float4x4 = closestResult.worldTransform
        let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        let node : SCNNode = createNewChildNode(text)
        sceneView.scene.rootNode.addChildNode(node)
        node.position = worldCoord
        Nodes.insert(node, at: number)
    }
    
    func selectedPinNode(number:Int, filter:String) {
        changeNodeText(text: filter, number: number)
    }
    
    func deselectPinNode(number:Int, filter:String) {
        changeNodeText(text: filter, number: number)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        // Enable Default Lighting - makes the 3D text a bit poppier.
        sceneView.autoenablesDefaultLighting = true
        // Tap Gesture Recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognize:)))
        self.sceneView.addGestureRecognizer(tapGesture)
        // Setup coreml model
        // Set up Vision Model
        guard let selectedModel = try? VNCoreMLModel(for: MobileNet().model) else { // (Optional) This can be replaced with other models on https://developer.apple.com/machine-learning/
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project from https://developer.apple.com/machine-learning/ . Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        // Set up Vision-CoreML Request
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Enable plane detection
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
//        sceneView.session.pause()
    }
    
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    var visionRequests = [VNRequest]()
    var latestPrediction : String = "…" // a variable containing the latest CoreML prediction
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // Do any desired updates to SceneKit here.
        }
    }
    
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
        // HIT TEST : REAL WORLD
        
        // Get Screen Centre
        let screenCentre:CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        let arHitTestResults:[ARHitTestResult] = sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform:matrix_float4x4 = closestResult.worldTransform
            let worldCoord:SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            // Create 3D Text
            let node:SCNNode = createNewChildNode(latestPrediction)
            sceneView.scene.rootNode.addChildNode(node)
            node.position = worldCoord
//            Nodes.append(node)
//            detectedObjectCode.append(latestPrediction)
//            closestResults.append(closestResult)
//            totalLength = Nodes.count
        }
    }
    
    
    func createNewChildNode(_ text : String) -> SCNNode {
        let prediction = text
        let textDepth : Float = 0.01
        let text = SCNText(string: text, extrusionDepth: CGFloat(textDepth))
        let font = UIFont(name: "Arial", size: 0.2)
        text.font = font
        text.alignmentMode = kCAAlignmentCenter
        text.firstMaterial?.diffuse.contents = UIColor.white
        text.firstMaterial?.specular.contents = UIColor.white
        text.firstMaterial?.isDoubleSided = true
        text.chamferRadius = CGFloat(textDepth)
        let (minBound, maxBound) = text.boundingBox
        let textNode = SCNNode(geometry: text)
        textNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, textDepth/2)
        textNode.scale = SCNVector3Make(0.2, 0.2, -0.2)
        
        
        let sphere = SCNSphere(radius: 0.002)
        sphere.firstMaterial?.diffuse.contents = UIColor.cyan
        let sphereNode = SCNNode(geometry: sphere)
//        sphereNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        sphereNode.position = SCNVector3Make(0, 0, 0)
        
        let plane = SCNPlane(width: CGFloat(0.2), height: CGFloat(0.1))
        plane.cornerRadius = plane.width
        let spriteKitScene = SKScene(fileNamed: "ProductInformation")
        spriteKitScene?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
        let image = SKSpriteNode(imageNamed: "Avatar")
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = prediction
        label.fontSize = 60
        spriteKitScene?.addChild(label)
//        spriteKitScene?.addChild(image)
        plane.firstMaterial?.diffuse.contents = spriteKitScene
        plane.firstMaterial?.isDoubleSided = false
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(0, 0.1, 0)
        
        let plane2 = SCNPlane(width: CGFloat(0.2), height: CGFloat(0.1))
        plane2.cornerRadius = plane2.width
        let spriteKitScene2 = SKScene(fileNamed: "ProductInformation")
        spriteKitScene2?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
        let image2 = SKSpriteNode(imageNamed: "Avatar")
        image2.size.height = 10
//        let label2 = SKLabelNode(fontNamed: "Arial")
//        label2.text = prediction
//        label2.fontSize = 60
//        spriteKitScene2?.addChild(label2)
        spriteKitScene2?.addChild(image2)
        plane2.firstMaterial?.diffuse.contents = spriteKitScene2
        plane2.firstMaterial?.isDoubleSided = false
        plane2.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        let planeNode2 = SCNNode(geometry: plane2)
        planeNode2.position = SCNVector3Make(0, 0.23, 0)
        
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        let childParent = SCNNode()
        childParent.addChildNode(sphereNode)
        childParent.addChildNode(planeNode2)
//        childParent.addChildNode(textNode)
        childParent.addChildNode(planeNode)
        childParent.constraints = [billboardConstraint]
        return childParent
    }
    
    func loopCoreMLUpdate() {
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        dispatchQueueML.async {
            // 1. Run Update.
            self.updateCoreML()
            // 2. Loop this function.
            self.loopCoreMLUpdate()
        }
    }
    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        // Catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        // Get Classifications
        let classifications = observations[0...1] // top 2 results
            .flatMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:"- %.2f", $0.confidence))" })
            .joined(separator: "\n")
        DispatchQueue.main.async {
            // Print Classifications
            //            print(classifications)
            //            print("--")
            
            // Display Debug Text on screen
            var debugText:String = ""
            debugText += classifications
            self.debugTextView.text = debugText
            // Store the latest prediction
            var objectName:String = "…"
            objectName = classifications.components(separatedBy: "-")[0]
            objectName = objectName.components(separatedBy: ",")[0]
            self.latestPrediction = objectName
            
        }
    }
    
    func updateCoreML() {
        // Get Camera Image as RGB
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        // Note: Not entirely sure if the ciImage is being interpreted as RGB, but for now it works with the Inception model.
        // Note2: Also uncertain if the pixelBuffer should be rotated before handing off to Vision (VNImageRequestHandler) - regardless, for now, it still works well with the Inception model.
        // Prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        // let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage!, orientation: myOrientation, options: [:]) // Alternatively; we can convert the above to an RGB CGImage and use that. Also UIInterfaceOrientation can inform orientation values.
        // Run Image Request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
        
    }
}
