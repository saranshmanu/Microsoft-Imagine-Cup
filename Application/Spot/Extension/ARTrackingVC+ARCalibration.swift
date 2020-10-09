//
//  ARTrackingVC+ARCalibration.swift
//  Spot
//
//  Created by Saransh Mittal on 08/10/20.
//  Copyright © 2020 dantish. All rights reserved.
//

import UIKit

extension ARTrackingVC {
    func initARCalibration() {
        self.calibrationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.trackARPoints), userInfo: nil, repeats: true)
    }
    @objc func trackARPoints() {
        let currentFrame = self._ARSession.currentFrame
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
        } else {}
    }
}
