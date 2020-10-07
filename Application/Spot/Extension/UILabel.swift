//
//  UILabel.swift
//  Spot
//
//  Created by Saransh Mittal on 08/10/20.
//  Copyright © 2020 dantish. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setTextColorToGradient(image: UIImage) {
        UIGraphicsBeginImageContext(frame.size)
        image.draw(in: bounds)
        let myGradient = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.textColor = UIColor(patternImage: myGradient!)
    }
}
