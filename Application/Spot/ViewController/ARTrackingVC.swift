//
//  ARTrackingVC.swift
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

class ARTrackingVC: UIViewController {
    

    @IBOutlet weak var calibrationText: UILabel!
    @IBOutlet weak var calibrationImage: UIImageView!
    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var calibrationLoaderView: UIView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var debugTextView: UITextView!
    
    var calibrationTimer: Timer!
    let animation = LOTAnimationView(name: "barcodeScanner")
    let _ARSession = ARSession()
    var visionRequests = [VNRequest]()
    var ARHitTestResults = [ARHitTestResult]()
    var DetectedProducts = [String]()
    var SCNNodes = [SCNNode]()
    var prediction: String = "…"
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initARCalibration()
        self.initMLPredictions()
        self.initSceneView()
        self.initARTrackingConfiguration()
        DispatchQueue.main.async { self.animateCalibrationView() }
        DispatchQueue.main.async { self.animateScannerView() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animation.play()
        DispatchQueue.main.async {
            self.updateSelectedFilters()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animation.pause()
    }

    func animateCalibrationView() {
        let calibrationViewImages = [
            "mid",
            "right",
            "mid",
            "left"
        ]
        calibrationText.alpha = 1.0
        self.calibrationImage.alpha = 1.0
        UIView.animate(withDuration: 1, animations: {
            self.calibrationText.alpha = 0.0
            self.calibrationImage.alpha = 0.0
            self.calibrationImage.image = UIImage.init(named: calibrationViewImages[self.number%calibrationViewImages.count])
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.number = self.number + 1
            self.animateCalibrationView()
        })
    }
    
    func animateScannerView() {
        DispatchQueue.main.async {
            self.animation.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.animation.contentMode = .scaleAspectFill
            self.animation.frame = self.scannerView.bounds
            self.animation.loopAnimation = true
            self.scannerView.addSubview(self.animation)
            self.view.layoutIfNeeded()
        }
    }
    
}
