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
import Lottie

class ARTrackingViewController: UIViewController, ARSCNViewDelegate {
    
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    let augmentedRealitySession = ARSession()
    
    @IBOutlet weak var calibrationText: UILabel!
    @IBOutlet weak var calibrationImage: UIImageView!
    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var calibrationLoaderView: UIView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var debugTextView: UITextView!
    var calibrationTimer: Timer!
    
    @objc func trackARPoints() {
        let currentFrame = self.augmentedRealitySession.currentFrame
        if currentFrame?.rawFeaturePoints?.points != nil {
            let featurePointsArray = currentFrame?.rawFeaturePoints?.points
            let totalPoints:Int = (featurePointsArray?.count)!
            if totalPoints >= 200 {
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 1) {
                    self.calibrationLoaderView.alpha = 0.0
                }
                calibrationTimer.invalidate()
            }
            print(totalPoints)
        } else {
//            print(0)
        }
    }

    var Nodes = [SCNNode]()
    var closestResults = [ARHitTestResult]()
    var detectedObjectCode = [String]()
    var totalLength = 0
    
    func changeNode(text:String, indexNumber:Int, listOfFilterImages:[String], totalFilters: Int){
        Nodes[indexNumber].removeFromParentNode()
        Nodes.remove(at: indexNumber)
        let closestResult = closestResults[indexNumber]
        let transform : matrix_float4x4 = closestResult.worldTransform
        let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        let node : SCNNode = createNewChildNode(detectedObjectCode[indexNumber], totalFilters: totalFilters, listOfFilterImages: listOfFilterImages)
        sceneView.scene.rootNode.addChildNode(node)
        node.position = worldCoord
        Nodes.insert(node, at: indexNumber)
    }
    
    var number = 0
    let calibrationViewImages = ["mid", "right", "mid", "left"]

    
    func animateCalibrationView() {
        calibrationText.alpha = 1.0
        self.calibrationImage.alpha = 1.0
        UIView.animate(withDuration: 1, animations: {
            self.calibrationText.alpha = 0.0
            self.calibrationImage.alpha = 0.0
            self.calibrationImage.image = UIImage.init(named: self.calibrationViewImages[self.number%self.calibrationViewImages.count])
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.number = self.number + 1
            self.animateCalibrationView()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            let boatAnimation = LOTAnimationView(name: "barcodeScanner")
            boatAnimation.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            boatAnimation.contentMode = .scaleAspectFill
            boatAnimation.frame = self.scannerView.bounds
            boatAnimation.loopAnimation = true
            boatAnimation.play()
            self.scannerView.addSubview(boatAnimation)
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.async {
            self.animateCalibrationView()
        }
        
//        let animationView = LOTAnimationView(name: "MovePhone")
//        animationView.autoresizingMask = [.flexibleHeight]
//        animationView.contentMode = .scaleAspectFit
//        let screenWidth:Int = Int(self.view.frame.width)
//        let screenHeight:Int = Int(self.view.frame.height)
//        animationView.center.x = CGFloat(screenWidth/2)
//        animationView.center.y = CGFloat(screenHeight/2)
//        animationView.loopAnimation = true
//        animationView.play()
//        self.calibrationLoaderView.addSubview(animationView)
//        self.calibrationLoaderView.layoutIfNeeded()
        
        self.calibrationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.trackARPoints), userInfo: nil, repeats: true)
        
        sceneView.session = augmentedRealitySession
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
        self.scannerView.addGestureRecognizer(tapGesture)
        
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
        

        // Enable plane detection
        if #available(iOS 11.3, *) {
            configuration.planeDetection = .vertical
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 12.0, *) {
            print("Available")
            configuration.environmentTexturing = .automatic
        } else {
            // Fallback on earlier versions
        }
        sceneView.session.run(configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        DispatchQueue.global().async {
            var temp = foodItem()
            let prediction = self.latestPrediction
            for i in 0...database.count - 1 {
                let flag = database[i] as NSDictionary
                let code = flag["Code"] as! String + " "
                if code == prediction {
                    print(code)
                    temp.foodID = flag["Code"] as! String
                    temp.foodName = flag["Name"] as! String
                    temp.foodDescription = flag["Description"] as! String
                    temp.foodType = flag["Type"] as! String
                    temp.Calorie = flag["Calorie"] as! Bool
                    temp.Nuts = flag["Nuts"] as! Bool
                    temp.Eggs = flag["Eggs"] as! Bool
                    temp.Sugar = flag["Sugar"] as! Bool
                    temp.Caffiene = flag["Caffiene"] as! Bool
                    temp.Lactose = flag["Lactose"] as! Bool
                    temp.Soya = flag["Soya"] as! Bool
                    temp.Vegan = flag["Vegan"] as! Bool
                    
                    temp.BabyFood = flag["BabyFood"] as! Bool
                    temp.DietFood = flag["DietFood"] as! Bool
                    temp.NutritionalFood = flag["NutritionalFood"] as! Bool
                    temp.SoftDrinks = flag["SoftDrinks"] as! Bool
                    temp.SportsDrink = flag["SportsDrink"] as! Bool
                    temp.GymFood = flag["GymFood"] as! Bool
                    temp.SpicyFood = flag["SpicyFood"] as! Bool
                    
                    let randomColor = Int.random(in: 1...themeColors.count)
                    temp.foodColorTheme = themeColors[randomColor - 1]
                }
            }
            detectedFood.append(temp)
            
            // Get Screen Centre
            let screenCentre:CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
            let arHitTestResults:[ARHitTestResult] = self.sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
            if let closestResult = arHitTestResults.first {
                // Get Coordinates of HitTest
                let transform:matrix_float4x4 = closestResult.worldTransform
                let worldCoord:SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                // Create 3D Text
                let node:SCNNode = self.createNewChildNode(temp.foodName, totalFilters: 0, listOfFilterImages: [])
                self.sceneView.scene.rootNode.addChildNode(node)
                node.position = worldCoord
                self.Nodes.append(node)
                self.closestResults.append(closestResult)
                self.detectedObjectCode.append(temp.foodName)
            }
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
        DispatchQueue.main.async {
            let totalDetected = detectedFood.count
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
                    if detectedFood[i].NutritionalFood == true && filtersSelectedBool.NutritionalFoodFilter == true {
                        listOfFilterImages.append(filterImagesName.NutritionalFoodFilter)
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
    
    
    func createNewChildNode(_ text:String, totalFilters: Int, listOfFilterImages: [String]) -> SCNNode {
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        let childParent = SCNNode()
        let prediction = text
        
        let planeText = DispatchQueue(label: "perform_task_with_plane_Text")
        let filters = DispatchQueue(label: "perform_task_with_filters")
        let pointer = DispatchQueue(label: "perform_task_with_pointer")
        
//        -----------------------------------------------------------------------------------------------
        
//        let textDepth : Float = 0.01
//        let text = SCNText(string: text, extrusionDepth: CGFloat(textDepth))
//        let font = UIFont(name: "Arial", size: 0.2)
//        text.font = font
//        text.alignmentMode = kCAAlignmentCenter
//        text.firstMaterial?.diffuse.contents = UIColor.white
//        text.firstMaterial?.specular.contents = UIColor.white
//        text.firstMaterial?.isDoubleSided = true
//        text.chamferRadius = CGFloat(textDepth)
//        let (minBound, maxBound) = text.boundingBox
//        let textNode = SCNNode(geometry: text)
//        textNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, textDepth/2)
//        textNode.scale = SCNVector3Make(0.2, 0.2, -0.2)
//        childParent.addChildNode(textNode)

        
//        -----------------------------------------------------------------------------------------------
        
        planeText.sync {
            let plane = SCNPlane(width: CGFloat(0.1), height: CGFloat(0.0326))
            plane.cornerRadius = 0
            let spriteKitScene = SKScene(fileNamed: "ProductInformation")
//        spriteKitScene?.backgroundColor = UIColor.blue
            let label = SKLabelNode(fontNamed: "Arial-Bold")
            label.text = prediction
            label.fontSize = 40
            spriteKitScene?.addChild(label)
            plane.firstMaterial?.diffuse.contents = spriteKitScene
            plane.firstMaterial?.isDoubleSided = false
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make(0, 0.1, 0)
            addAnimation(node: planeNode)
            childParent.addChildNode(planeNode)
        }
        
//        -----------------------------------------------------------------------------------------------

        filters.sync {
            let flag = totalFilters
            if flag != 0 {
                for i in 1...flag {
                    let filterCard = SCNPlane(width: CGFloat(0.2), height: CGFloat(0.1))
                    filterCard.cornerRadius = 0
                    let filterCardScene = SKScene(fileNamed: "Product")
                    filterCardScene?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
                    let filterCardImage = SKSpriteNode(imageNamed: listOfFilterImages[i-1]) // listOfFilterImages[i]
                    //filterCardImage.size.height = (filterCardScene?.frame.height)!
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
        }
        
//        -----------------------------------------------------------------------------------------------
        pointer.sync {
//            for _ in 0...10 {
//                let randomx = Float.random(in: -5...5) / 200
//                let randomy = Float.random(in: -5...5) / 200
//                let randomz = Float.random(in: -5...5) / 200
//                let sphere = SCNSphere(radius: 0.001)
//                sphere.firstMaterial?.diffuse.contents = UIColor.yellow
//                let sphereNode = SCNNode(geometry: sphere)
//                sphereNode.position = SCNVector3Make(randomx, randomy, randomz)
//                childParent.addChildNode(sphereNode)
//            }
        }
        
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
            .compactMap({ $0 as? VNClassificationObservation })
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
