//
//  ARTrackingVC+ARScene.swift
//  Spot
//
//  Created by Saransh Mittal on 08/10/20.
//  Copyright © 2020 dantish. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import UIKit

extension ARTrackingVC: ARSCNViewDelegate {
    func initSceneView() {
        sceneView.session = _ARSession
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true
        self.scannerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.capture(gestureRecognize:))))
    }
    
    func initARTrackingConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.environmentTexturing = .automatic
        configuration.planeDetection = .vertical
        sceneView.session.run(configuration)
    }
    
    func updateSelectedFilters() {
        var index = 0
        for product in products {
            var filters = [String]()
            if product.DietFood == true && _FilterSelected.Diet == true { filters.append(_FilterImage.DietFood) }
            if product.BabyFood == true && _FilterSelected.Baby == true { filters.append(_FilterImage.BabyFood) }
            if product.GymFood == true && _FilterSelected.Gym == true { filters.append(_FilterImage.GymFood) }
            if product.NutritionalFood == true && _FilterSelected.Nutritional == true { filters.append(_FilterImage.NutritionalFood) }
            if product.SpicyFood == true && _FilterSelected.SpicyFood == true { filters.append(_FilterImage.SpicyFood) }
            if product.SportsDrink == true && _FilterSelected.Sport == true { filters.append(_FilterImage.SportsDrink) }
            if product.SoftDrinks == true && _FilterSelected.SoftDrink == true { filters.append(_FilterImage.SoftDrink) }
            if product.Calorie == true && _FilterSelected.Calorie == true { filters.append(_FilterImage.Calorie) }
            if product.Nuts == true && _FilterSelected.Nuts == true { filters.append(_FilterImage.Nuts) }
            if product.Eggs == true && _FilterSelected.Eggs == true { filters.append(_FilterImage.Eggs) }
            if product.Sugar == true && _FilterSelected.Sugar == true { filters.append(_FilterImage.Sugar) }
            if product.Caffiene == true && _FilterSelected.Caffiene == true { filters.append(_FilterImage.Caffiene) }
            if product.Lactose == true && _FilterSelected.Lactose == true { filters.append(_FilterImage.Lactose) }
            if product.Soya == true && _FilterSelected.Soya == true { filters.append(_FilterImage.Soya) }
            if product.Vegan == true && _FilterSelected.Vegan == true { filters.append(_FilterImage.Vegan) }
            self.updateNode(index: index, filters: filters, count: filters.count)
            index += 1
        }
    }
    
    func updateNode(index:Int, filters:[String], count: Int){
        SCNNodes[index].removeFromParentNode()
        SCNNodes.remove(at: index)
        let closestResult = ARHitTestResults[index]
        let ARCoordinates: matrix_float4x4 = closestResult.worldTransform
        let SCNCoordinates: SCNVector3 = SCNVector3Make(ARCoordinates.columns.3.x, ARCoordinates.columns.3.y, ARCoordinates.columns.3.z)
        let SCNNode: SCNNode = createProductSCNNode(DetectedProducts[index], total: count, filters: filters, warning: products[index].warning)
        sceneView.scene.rootNode.addChildNode(SCNNode)
        SCNNode.position = SCNCoordinates
        SCNNodes.insert(SCNNode, at: index)
    }

    @objc func capture(gestureRecognize: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            var product: Product?
            let prediction = self.prediction
            for record in database {
                let code = record["Code"] as! String + " "
                if code == prediction {
                    product = Product(product: record as NSDictionary)
                    product?.warning = !(product?.Nuts ?? false)
                    let randomColor = Int.random(in: 1...themeColors.count)
                    product?.foodColorTheme = themeColors[randomColor - 1]
                }
            }
            if (product == nil) { return }
            products.append(product!)
            
            let screenCentre:CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
            let ARResults: [ARHitTestResult] = self.sceneView.hitTest(screenCentre, types: [.featurePoint])
            if let closestResult = ARResults.first {
                let ARCoordinates: matrix_float4x4 = closestResult.worldTransform
                let SCNCoordinates: SCNVector3 = SCNVector3Make(ARCoordinates.columns.3.x, ARCoordinates.columns.3.y, ARCoordinates.columns.3.z)
                let checkWarning = product?.warning ?? false
                let SCNNode: SCNNode = self.createProductSCNNode(product!.foodName, total: 0, filters: [], warning: checkWarning)
                self.sceneView.scene.rootNode.addChildNode(SCNNode)
                SCNNode.position = SCNCoordinates
                self.SCNNodes.append(SCNNode)
                self.ARHitTestResults.append(closestResult)
                self.DetectedProducts.append(product!.foodName)
            }
        }
    }
    
    func createProductSCNNode(_ prediction: String, total: Int, filters: [String], warning:Bool) -> SCNNode {
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        let SCNParentNode = SCNNode()
        
        DispatchQueue(label: "perform_task_with_plane_Text").sync {
            let label = SKLabelNode(fontNamed: "Arial-Bold")
            label.text = prediction
            label.fontSize = 40
            let spriteKitScene = SKScene(fileNamed: "ProductInformation")
            spriteKitScene?.addChild(label)
            let plane = SCNPlane(width: CGFloat(0.2), height: CGFloat(0.0652))
            plane.cornerRadius = 0
            plane.firstMaterial?.diffuse.contents = spriteKitScene
            plane.firstMaterial?.isDoubleSided = false
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3Make(0, 0.1, 0)
            SCNParentNode.addChildNode(planeNode)
        }

        var yAxis:Double = 0
        DispatchQueue(label: "perform_task_with_filters").sync {
            let flag = total
            if flag != 0 {
                for i in 1...flag {
                    let filterCard = SCNPlane(width: CGFloat(0.2), height: CGFloat(0.1))
                    filterCard.cornerRadius = 0
                    let filterCardScene = SKScene(fileNamed: "Product")
                    filterCardScene?.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
                    let filterCardImage = SKSpriteNode(imageNamed: filters[i-1]) // listOfFilterImages[i]
                    filterCardScene?.addChild(filterCardImage)
                    filterCard.firstMaterial?.diffuse.contents = filterCardScene
                    filterCard.firstMaterial?.isDoubleSided = false
                    filterCard.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
                    let filterCardNode = SCNNode(geometry: filterCard)
                    yAxis = (Double(i)) * 0.11 + 0.09
                    filterCardNode.position = SCNVector3Make(0, Float(yAxis), 0)
                    SCNParentNode.addChildNode(filterCardNode)
                    
                }
            }
        }
        
        DispatchQueue(label: "perform_task_with_pointer").sync {
            if warning == true {
                let plane = SCNPlane(width: CGFloat(0.2), height: CGFloat(0.35))
                plane.cornerRadius = 0
                let spriteKitScene = SKScene(fileNamed: "Warning")
                plane.firstMaterial?.diffuse.contents = spriteKitScene
                plane.firstMaterial?.isDoubleSided = false
                plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
                let planeNode = SCNNode(geometry: plane)
                planeNode.position = SCNVector3Make(0, Float(yAxis) + 0.3 + 0.02, 0)
                SCNParentNode.addChildNode(planeNode)
            }
        }
        
        SCNParentNode.constraints = [billboardConstraint]
        return SCNParentNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // Do any desired updates to SceneKit here.
        }
    }
}
