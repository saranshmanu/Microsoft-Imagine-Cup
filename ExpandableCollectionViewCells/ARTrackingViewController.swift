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

class ARTrackingViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var debugTextView: UITextView!
    
    var Nodes = [SCNNode]()
    var closestResults = [ARHitTestResult]()
    var detectedObjectCode = [String]()
    var totalLength = 0
    
    func changeNode(text:String, indexNumber:Int, listOfFilterImages:[String], totalFilters: Int){
        print("Changing nodes")
        Nodes[indexNumber].removeFromParentNode()
        Nodes.remove(at: indexNumber)
        var closestResult = closestResults[indexNumber]
        let transform : matrix_float4x4 = closestResult.worldTransform
        let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        let node : SCNNode = createNewChildNode(detectedObjectCode[indexNumber], totalFilters: totalFilters, listOfFilterImages: listOfFilterImages)
        sceneView.scene.rootNode.addChildNode(node)
        node.position = worldCoord
        Nodes.insert(node, at: indexNumber)
    }
    
//    func selectedPinNode(number:Int, filter:String) {
//        changeNodeText(text: filter, number: number)
//    }
//
//    func deselectPinNode(number:Int, filter:String) {
//        changeNodeText(text: filter, number: number)
//    }
    
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
        guard let selectedModel = try? VNCoreMLModel(for: foodModel().model) else { // (Optional) This can be replaced with other models on https://developer.apple.com/machine-learning/
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project from https://developer.apple.com/machine-learning/ . Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        // Set up Vision-CoreML Request
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
        // Do any additional setup after loading the view.
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Enable plane detection
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let totalDetected = detectedFood.count
        DispatchQueue.main.async {
            if totalDetected != 0{
                for i in 0...(totalDetected-1) {
                    var listOfFilterImages = [String]()
                    if detectedFood[i].DietFood == true && filtersSelectedBool.DietFoodFilter == true{
                        listOfFilterImages.append(filterImagesName.DietFoodFilter)
                    }
                    if detectedFood[i].BabyFood == true && filtersSelectedBool.BabyFoodFilter == true {
                        listOfFilterImages.append(filterImagesName.BabyFoodFilter)
                    }
                    if detectedFood[i].GymFood == true && filtersSelectedBool.GymFoodFilter == true {
                        listOfFilterImages.append(filterImagesName.GymFoodFilter)
                    }
                    if detectedFood[i].NutitionalFood == true && filtersSelectedBool.NutitionalFoodFilter == true {
                        listOfFilterImages.append(filterImagesName.NutitionalFoodFilter)
                    }
                    if detectedFood[i].SpicyFood == true && filtersSelectedBool.SpicyFoodFilter == true {
                        listOfFilterImages.append(filterImagesName.SpicyFoodFilter)
                    }
                    if detectedFood[i].SportsDrink == true && filtersSelectedBool.SportsDrinkFilter == true {
                        listOfFilterImages.append(filterImagesName.SportsDrinkFilter)
                    }
                    if detectedFood[i].SoftDrinks == true && filtersSelectedBool.SoftDrinksFilter == true {
                        listOfFilterImages.append(filterImagesName.SoftDrinksFilter)
                    }
                    if detectedFood[i].Calorie == true && filtersSelectedBool.CalorieFilter == true {
                        listOfFilterImages.append(filterImagesName.CalorieFilter)
                    }
                    if detectedFood[i].Nuts == true && filtersSelectedBool.NutsFilter == true {
                        listOfFilterImages.append(filterImagesName.NutsFilter)
                    }
                    if detectedFood[i].Eggs == true && filtersSelectedBool.EggsFilter == true {
                        listOfFilterImages.append(filterImagesName.EggsFilter)
                    }
                    if detectedFood[i].Sugar == true && filtersSelectedBool.SugarFilter == true {
                        listOfFilterImages.append(filterImagesName.SugarFilter)
                    }
                    if detectedFood[i].Caffiene == true && filtersSelectedBool.CaffieneFilter == true {
                        listOfFilterImages.append(filterImagesName.CaffieneFilter)
                    }
                    if detectedFood[i].Lactose == true && filtersSelectedBool.LactoseFilter == true {
                        listOfFilterImages.append(filterImagesName.LactoseFilter)
                    }
                    if detectedFood[i].Soya == true && filtersSelectedBool.SoyaFilter == true {
                        listOfFilterImages.append(filterImagesName.SoyaFilter)
                    }
                    if detectedFood[i].Vegan == true && filtersSelectedBool.VeganFilter == true {
                        listOfFilterImages.append(filterImagesName.VeganFilter)
                    }
                    print(listOfFilterImages.count)
                    self.changeNode(text: "", indexNumber: i, listOfFilterImages: listOfFilterImages, totalFilters: listOfFilterImages.count)
                }
            }
        }
        
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
        // here the latest prediction will be used as the id to be sent to the cloud and once after receiveing the information about the product the app continues till then I will show a loader that the object is bering detected
        var temp = foodItem()
        let prediction = latestPrediction
        for i in 0...database.count - 1 {
            let flag = database[i] as NSDictionary
            let code = flag["Code"] as! String + " "
            if code == prediction {
                print(code)
                temp.foodID = flag["Code"] as! String
                temp.foodName = flag["Name"] as! String
                temp.Calorie = flag["Calorie"] as! Bool
                temp.Nuts = flag["Nuts"] as! Bool
                temp.Eggs = flag["Eggs"] as! Bool
                temp.Sugar = flag["Sugar"] as! Bool
                temp.Caffiene = flag["Caffiene"] as! Bool
                temp.Lactose = flag["Lactose"] as! Bool
                temp.Soya = flag["Soya"] as! Bool
                temp.Vegan = flag["Vegan"] as! Bool
            }
        }
        detectedFood.append(temp)
        
        // Get Screen Centre
        let screenCentre:CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        let arHitTestResults:[ARHitTestResult] = sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform:matrix_float4x4 = closestResult.worldTransform
            let worldCoord:SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            // Create 3D Text
            let node:SCNNode = createNewChildNode(temp.foodName, totalFilters: 0, listOfFilterImages: [])
            sceneView.scene.rootNode.addChildNode(node)
            node.position = worldCoord
            Nodes.append(node)
            closestResults.append(closestResult)
            detectedObjectCode.append(temp.foodName)
        }
    }
    
    func addAnimation(node: SCNNode) {
//        let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 5.0)
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.02, z: 0, duration: 2.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.02, z: 0, duration: 2.5)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let rotateAndHover = SCNAction.group([hoverSequence])
        let repeatForever = SCNAction.repeatForever(rotateAndHover)
        node.runAction(repeatForever)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View appeared again")
    }
    
    
    func createNewChildNode(_ text:String, totalFilters: Int, listOfFilterImages: [String]) -> SCNNode {
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        let childParent = SCNNode()
        
//        -----------------------------------------------------------------------------------------------
        
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
        
//        -----------------------------------------------------------------------------------------------

        
        let plane = SCNPlane(width: CGFloat(0.2), height: CGFloat(0.05))
        plane.cornerRadius = 0
        let spriteKitScene = SKScene(fileNamed: "ProductInformation")
//        spriteKitScene?.backgroundColor = UIColor.blue
        let label = SKLabelNode(fontNamed: "Arial-Bold")
        label.text = prediction
        label.fontSize = 60
        spriteKitScene?.addChild(label)
        plane.firstMaterial?.diffuse.contents = spriteKitScene
        plane.firstMaterial?.isDoubleSided = false
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(0, 0.1, 0)
        addAnimation(node: planeNode)
        
//        -----------------------------------------------------------------------------------------------

        let flag = totalFilters
        
        if flag != 0 {
            for i in 1...flag {
                let filterCard = SCNPlane(width: CGFloat(0.2), height: CGFloat(0.1))
                filterCard.cornerRadius = 0
                let filterCardScene = SKScene(fileNamed: "Product")
                filterCardScene?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
                let filterCardImage = SKSpriteNode(imageNamed: listOfFilterImages[i-1]) // listOfFilterImages[i]
//                filterCardImage.size.height = (filterCardScene?.frame.height)!
                filterCardScene?.addChild(filterCardImage)
                filterCard.firstMaterial?.diffuse.contents = filterCardScene
                filterCard.firstMaterial?.isDoubleSided = false
                filterCard.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
                let filterCardNode = SCNNode(geometry: filterCard)
                let yAxis = (Double(i)) * 0.11 + 0.09
                filterCardNode.position = SCNVector3Make(0, Float(yAxis), 0)
                childParent.addChildNode(filterCardNode)
                
            }
        }
        
        
//        -----------------------------------------------------------------------------------------------

        
        for _ in 0...100 {
            let randomx = Float.random(in: -5...5) / 200
            let randomy = Float.random(in: -5...5) / 200
            let randomz = Float.random(in: -5...5) / 200

            let sphere = SCNSphere(radius: 0.001)
            sphere.firstMaterial?.diffuse.contents = UIColor.yellow
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.position = SCNVector3Make(randomx, randomy, randomz)
            childParent.addChildNode(sphereNode)
        }
        

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
